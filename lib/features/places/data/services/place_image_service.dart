import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:timeexplorer/core/config/app_config.dart';

class PlaceImageService {
  static const int _thumbWidth = 800;
  static const int _perQueryLimit = 6;
  static const int _maxImages = 10;
  static const String _geminiModel = 'gemini-1.5-flash';

  // Required by Wikimedia API etiquette — missing UA causes rate-limiting/rejection.
  static const String _userAgent =
      'TimeExplorer/1.0 (Flutter educational app; usmansardar037@gmail.com)';

  static final Map<String, List<String>> _cache = {};

  // ── Public API ────────────────────────────────────────────────────────────

  static Future<List<String>> fetchImages(String placeName) async {
    if (_cache.containsKey(placeName)) {
      debugPrint('[Gallery] Cache hit "$placeName": ${_cache[placeName]!.length} imgs');
      return _cache[placeName]!;
    }

    debugPrint('[Gallery] ══ fetchImages START ══ "$placeName"');

    final urls = <String>[];
    final seen = <String>{};

    void merge(List<String> batch) {
      for (final u in batch) {
        if (seen.add(u) && urls.length < _maxImages) urls.add(u);
      }
    }

    // Step 1 — Gemini-expanded queries → Commons file search
    final geminiQueries = await _geminiExpandQueries(placeName);
    debugPrint('[Gallery] Gemini → ${geminiQueries.length} queries: $geminiQueries');
    if (geminiQueries.isNotEmpty) {
      merge(await _fetchMultiQuery(geminiQueries));
      debugPrint('[Gallery] After Gemini+Commons: ${urls.length} URLs');
    }

    // Step 2 — Direct Commons search with place name (always runs)
    if (urls.length < _maxImages) {
      merge(await _commonsSearch(placeName));
      debugPrint('[Gallery] After direct Commons: ${urls.length} URLs');
    }

    // Step 3 — Wikipedia article images (most reliable for famous places)
    if (urls.length < 3) {
      merge(await _wikipediaArticleImages(placeName));
      debugPrint('[Gallery] After Wikipedia article imgs: ${urls.length} URLs');
    }

    // Step 4 — Shortened-name fallbacks
    if (urls.length < 2) {
      merge(await _shortenedFallback(placeName, seen));
      debugPrint('[Gallery] After shortened fallback: ${urls.length} URLs');
    }

    debugPrint('[Gallery] ══ fetchImages DONE ══ ${urls.length} URLs for "$placeName"');
    _cache[placeName] = urls;
    return urls;
  }

  static void clearCache() => _cache.clear();

  // ── Step 1 helpers ────────────────────────────────────────────────────────

  static Future<List<String>> _geminiExpandQueries(String placeName) async {
    try {
      final apiKey = AppConfig.geminiApiKey;
      if (apiKey.isEmpty) {
        debugPrint('[Gallery] Gemini key empty — skipping');
        return [];
      }
      final model = GenerativeModel(model: _geminiModel, apiKey: apiKey);
      final prompt =
          'You are a photo search assistant. Given a place name, return exactly '
          '4 short image search queries for Wikimedia Commons that would find '
          'different high-quality photos (e.g. exterior, interior, aerial, '
          'detail view). Return ONLY the 4 queries, one per line, no numbering, '
          'no extra text.\nPlace: $placeName';

      final response = await model
          .generateContent([Content.text(prompt)])
          .timeout(const Duration(seconds: 12));

      final text = response.text ?? '';
      return text
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty && l.length > 3)
          .take(4)
          .toList();
    } catch (e) {
      debugPrint('[Gallery] Gemini EXCEPTION: $e');
      return [];
    }
  }

  static Future<List<String>> _fetchMultiQuery(List<String> queries) async {
    final results = await Future.wait(
      queries.map((q) => _commonsSearch(q)),
      eagerError: false,
    );
    final seen = <String>{};
    final merged = <String>[];
    for (final batch in results) {
      for (final url in batch) {
        if (seen.add(url) && merged.length < _maxImages) merged.add(url);
      }
    }
    return merged;
  }

  // ── Step 2 — Wikimedia Commons file search ────────────────────────────────

  static Future<List<String>> _commonsSearch(String query) async {
    debugPrint('[Gallery] _commonsSearch("$query")');
    try {
      final uri = Uri.https('commons.wikimedia.org', '/w/api.php', {
        'action': 'query',
        'generator': 'search',
        'gsrnamespace': '6',
        'gsrsearch': query,
        'gsrlimit': '$_perQueryLimit',
        'prop': 'imageinfo',
        'iiprop': 'url|mime',
        'iiurlwidth': '$_thumbWidth',
        'format': 'json',
        'origin': '*',
      });

      debugPrint('[Gallery] → $uri');

      final response = await http
          .get(uri, headers: {'User-Agent': _userAgent})
          .timeout(const Duration(seconds: 15));

      debugPrint('[Gallery] Commons HTTP ${response.statusCode} for "$query"');

      if (response.statusCode != 200) {
        debugPrint('[Gallery] Commons error body: ${_snip(response.body)}');
        return [];
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final pages = data['query']?['pages'] as Map<String, dynamic>?;

      if (pages == null) {
        debugPrint('[Gallery] Commons: 0 results for "$query". Body: ${_snip(response.body)}');
        return [];
      }

      debugPrint('[Gallery] Commons: ${pages.length} pages for "$query"');
      return _extractUrls(pages);
    } catch (e) {
      debugPrint('[Gallery] _commonsSearch EXCEPTION: $e');
      return [];
    }
  }

  // ── Step 3 — Wikipedia article images (curated, always relevant) ──────────

  static Future<List<String>> _wikipediaArticleImages(String placeName) async {
    debugPrint('[Gallery] _wikipediaArticleImages("$placeName")');
    try {
      final uri = Uri.https('en.wikipedia.org', '/w/api.php', {
        'action': 'query',
        'titles': placeName,
        'generator': 'images',
        'gimlimit': '20',
        'prop': 'imageinfo',
        'iiprop': 'url|mime',
        'iiurlwidth': '$_thumbWidth',
        'format': 'json',
        'origin': '*',
      });

      final response = await http
          .get(uri, headers: {'User-Agent': _userAgent})
          .timeout(const Duration(seconds: 15));

      debugPrint('[Gallery] Wikipedia HTTP ${response.statusCode} for "$placeName"');

      if (response.statusCode != 200) return [];

      final data = json.decode(response.body) as Map<String, dynamic>;
      final pages = data['query']?['pages'] as Map<String, dynamic>?;

      if (pages == null) {
        debugPrint('[Gallery] Wikipedia: no pages for "$placeName"');
        return [];
      }

      final urls = _extractUrls(pages);
      debugPrint('[Gallery] Wikipedia: ${urls.length} images for "$placeName"');
      return urls;
    } catch (e) {
      debugPrint('[Gallery] _wikipediaArticleImages EXCEPTION: $e');
      return [];
    }
  }

  // ── Step 4 — Shortened name fallback ─────────────────────────────────────

  static Future<List<String>> _shortenedFallback(
    String placeName,
    Set<String> seen,
  ) async {
    final candidates = <String>[];
    final shortened = placeName.split(RegExp(r'[,\-–]')).first.trim();
    if (shortened.isNotEmpty && shortened != placeName) {
      candidates.add(shortened);
    }
    final firstWord = placeName.split(' ').first;
    if (firstWord.isNotEmpty &&
        firstWord != placeName &&
        firstWord != shortened) {
      candidates.add(firstWord);
    }

    final urls = <String>[];
    for (final v in candidates) {
      final batch = await _commonsSearch(v);
      for (final u in batch) {
        if (seen.add(u) && urls.length < _maxImages) urls.add(u);
      }
      if (urls.length >= 3) break;
    }
    return urls;
  }

  // ── Shared helpers ────────────────────────────────────────────────────────

  static List<String> _extractUrls(Map<String, dynamic> pages) {
    final urls = <String>[];
    for (final page in pages.values) {
      final infoList = page['imageinfo'] as List?;
      if (infoList == null || infoList.isEmpty) continue;
      final info = infoList[0] as Map<String, dynamic>;
      final mime = (info['mime'] as String? ?? '').toLowerCase();
      final thumb = info['thumburl'] as String?;
      final full = info['url'] as String?;
      final url = (thumb?.isNotEmpty == true ? thumb : full) ?? '';
      final valid = url.isNotEmpty && _isValidMime(mime, url);
      debugPrint('[Gallery]  ↳ mime=$mime valid=$valid url=${_snip(url, 80)}');
      if (valid) urls.add(url);
    }
    return urls;
  }

  static bool _isValidMime(String mime, String url) {
    if (mime == 'image/svg+xml') return false;
    if (mime.startsWith('image/')) return true;
    final lower = url.toLowerCase().split('?').first;
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp');
  }

  static String _snip(String s, [int len = 200]) =>
      s.substring(0, s.length.clamp(0, len));
}
