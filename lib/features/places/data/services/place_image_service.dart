import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:timeexplorer/core/services/api_service.dart';

class PlaceImageService {
  static const int _thumbWidth = 800;
  static const int _maxRaw = 20;   // collected before filtering
  static const int _maxFinal = 10; // kept after filtering
  static const int _perQueryLimit = 6;

  static const String _userAgent =
      'TimeExplorer/1.0 (Flutter educational app; usmansardar037@gmail.com)';

  // ── Junk filter ──────────────────────────────────────────────────────────
  // Excludes logos, maps, icons, flags, text screenshots, and other non-scenic content.
  static final RegExp _junkPattern = RegExp(
    r'('
    r'logo|'
    r'coat[_\-]of[_\-]arms|'
    r'locator|'
    r'screenshot|'
    r'emblem|'
    r'diagram|'
    r'floor[_\-]?plan|'
    r'[_\-/]map[_\-/.]|map_of_|'
    r'flag_of_|[_\-/]flag[_\-/.]|'
    r'[_\-/]icon[_\-/.]|'
    r'[_\-/]text[_\-/.]|'
    r'[_\-/]seal[_\-/.]|seal_of_|'
    r'wikipedia_|wikimedia_logo'
    r')',
    caseSensitive: false,
  );

  static final Map<String, List<String>> _cache = {};

  // ── Public API ────────────────────────────────────────────────────────────

  static Future<List<String>> fetchImages(String placeName) async {
    if (_cache.containsKey(placeName)) {
      debugPrint('[Gallery] Cache hit "$placeName": ${_cache[placeName]!.length} imgs');
      return _cache[placeName]!;
    }

    debugPrint('[Gallery] ══ fetchImages START ══ "$placeName"');

    final raw = <String>[];
    final rawSeen = <String>{};

    void merge(List<String> batch) {
      for (final u in batch) {
        if (rawSeen.add(u) && raw.length < _maxRaw) raw.add(u);
      }
    }

    // Step 1 — Gemini-expanded queries → Commons file search
    final geminiQueries = await _geminiExpandQueries(placeName);
    debugPrint('[Gallery] Gemini → ${geminiQueries.length} queries: $geminiQueries');
    if (geminiQueries.isNotEmpty) {
      merge(await _fetchMultiQuery(geminiQueries));
    }

    // Step 2 — Direct Commons search (always runs)
    if (raw.length < _maxRaw) {
      merge(await _commonsSearch(placeName));
    }

    // Step 3 — Wikipedia article images (curated, most reliable)
    if (raw.length < 5) {
      merge(await _wikipediaArticleImages(placeName));
    }

    // Step 4 — Shortened-name fallbacks (last resort)
    if (raw.length < 3) {
      merge(await _shortenedFallback(placeName, rawSeen));
    }

    debugPrint('[Gallery] Raw pool: ${raw.length} URLs — running filter+validate');

    // ── Filtering pipeline ────────────────────────────────────────────────
    final filtered = await _filterAndValidate(raw);

    debugPrint('[Gallery] ══ FINAL: ${filtered.length} quality images for "$placeName" ══');
    _cache[placeName] = filtered;
    return filtered;
  }

  static void clearCache() => _cache.clear();

  // ── Filtering pipeline ────────────────────────────────────────────────────

  static Future<List<String>> _filterAndValidate(List<String> raw) async {
    if (raw.isEmpty) return [];

    // 1. Relevance filter — exclude junk by URL path pattern
    final relevant = raw.where((url) {
      final path = Uri.tryParse(url)?.path ?? url;
      return !_junkPattern.hasMatch(path);
    }).toList();
    debugPrint('[Gallery] Relevance filter: ${raw.length} → ${relevant.length}');

    if (relevant.isEmpty) return [];

    // 2. Strict dedup — normalize to catch size-variant duplicates
    final seen = <String>{};
    final deduped =
        relevant.where((url) => seen.add(_normalizeUrl(url))).toList();
    debugPrint('[Gallery] Dedup: ${relevant.length} → ${deduped.length}');

    // 3. Parallel HEAD validation — drop non-200 and non-image responses
    final checks = await Future.wait(
      deduped.map(_validateUrl),
      eagerError: false,
    );

    final validated = <String>[
      for (var i = 0; i < deduped.length; i++)
        if (checks[i]) deduped[i],
    ];
    debugPrint('[Gallery] HEAD validation: ${deduped.length} → ${validated.length}');

    return validated.take(_maxFinal).toList();
  }

  static Future<bool> _validateUrl(String url) async {
    try {
      final response = await http
          .head(Uri.parse(url), headers: {'User-Agent': _userAgent})
          .timeout(const Duration(seconds: 5));

      // 405 = CDN doesn't support HEAD — assume valid
      if (response.statusCode == 405) return true;
      if (response.statusCode != 200) return false;

      final ct = response.headers['content-type'] ?? '';
      // Must be an image and not SVG (already filtered by _isValidMime,
      // but double-check here since HEAD confirms actual server response)
      return ct.startsWith('image/') && !ct.contains('svg');
    } catch (_) {
      // Timeout or network error — assume valid, let CachedNetworkImage handle it
      return true;
    }
  }

  static String _normalizeUrl(String url) {
    // Strip query params, lowercase, and collapse Wikimedia size prefix
    // e.g. ".../800px-Colosseum.jpg" → ".../colosseum.jpg"
    return url
        .split('?')
        .first
        .toLowerCase()
        .replaceAll(RegExp(r'/\d+px-'), '/');
  }

  // ── Step 1 helpers ────────────────────────────────────────────────────────

  static Future<List<String>> _geminiExpandQueries(String placeName) async {
    try {
      final prompt =
          'You are a photo search assistant. Given a place name, return exactly '
          '4 short image search queries for Wikimedia Commons that would find '
          'different high-quality photos (e.g. exterior, interior, aerial, '
          'detail view). Return ONLY the 4 queries, one per line, no numbering, '
          'no extra text.\nPlace: $placeName';

      final api = ApiService();
      final data = await api.post('/ai/ask', {'prompt': prompt});
      final text = (data['response'] as String? ?? '').trim();
      return text
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty && l.length > 3)
          .take(4)
          .toList();
    } catch (e) {
      debugPrint('[Gallery] AI query expansion failed (non-fatal): $e');
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
        if (seen.add(url) && merged.length < _maxRaw) merged.add(url);
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

      final response = await http
          .get(uri, headers: {'User-Agent': _userAgent})
          .timeout(const Duration(seconds: 15));

      debugPrint('[Gallery] Commons HTTP ${response.statusCode} for "$query"');
      if (response.statusCode != 200) {
        debugPrint('[Gallery] Commons error: ${_snip(response.body)}');
        return [];
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final pages = data['query']?['pages'] as Map<String, dynamic>?;
      if (pages == null) {
        debugPrint('[Gallery] Commons: 0 results for "$query"');
        return [];
      }

      debugPrint('[Gallery] Commons: ${pages.length} pages for "$query"');
      return _extractUrls(pages);
    } catch (e) {
      debugPrint('[Gallery] _commonsSearch EXCEPTION: $e');
      return [];
    }
  }

  // ── Step 3 — Wikipedia article images ────────────────────────────────────

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
      debugPrint('[Gallery] Wikipedia: ${urls.length} imgs for "$placeName"');
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
        if (seen.add(u) && urls.length < _maxRaw) urls.add(u);
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
      if (url.isNotEmpty && _isValidMime(mime, url)) urls.add(url);
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
