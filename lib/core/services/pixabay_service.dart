import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:timeexplorer/core/config/app_config.dart';

class PixabayService {
  static const String _baseUrl = 'https://pixabay.com/api/';
  static String get _apiKey => AppConfig.pixabayApiKey;
  static const String _userAgent = 'TimeExplorer/1.0 (Flutter educational app)';

  // In-memory cache to prevent redundant API calls
  static final Map<String, String> _urlCache = {};
  // Track queries that failed to find an image to avoid redundant calls
  static final Set<String> _failedQueries = {};

  /// Fetches a list of image URLs for a given [query].
  Future<List<String>> getImageUrls(String query, {int limit = 5}) async {
    debugPrint('[Pixabay] Request started for "$query"');
    if (_apiKey.isEmpty) {
      debugPrint('[Pixabay] Request skipped: API key is missing');
      return [];
    }

    try {
      final uri = Uri.parse(_baseUrl).replace(queryParameters: {
        'key': _apiKey,
        'q': query,
        'image_type': 'photo',
        'per_page': limit.toString(),
        'safesearch': 'true',
      });

      final response = await http
          .get(uri, headers: {'User-Agent': _userAgent})
          .timeout(const Duration(seconds: 10));
      debugPrint('[Pixabay] HTTP status: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('[Pixabay] Response received');
        final data = json.decode(response.body) as Map<String, dynamic>;
        final hits = data['hits'] as List<dynamic>? ?? const [];
        debugPrint('[Pixabay] Number of hits: ${hits.length}');
        debugPrint('[Pixabay] Raw results: ${hits.length}');

        if (hits.isNotEmpty) {
          final extracted = hits
              .whereType<Map<String, dynamic>>()
              .map((hit) => (hit['largeImageURL'] as String?) ??
                  (hit['webformatURL'] as String?) ?? '')
              .where((url) => url.startsWith('https://'))
              .toList();
          debugPrint('[Pixabay] After URL extraction: ${extracted.length}');

          final relevant = extracted.where(_isRelevantUrl).toList();
          debugPrint('[Pixabay] After relevance filter: ${relevant.length}');

          final seen = <String>{};
          final deduped = relevant
              .where((url) => seen.add(_normalizeUrl(url)))
              .toList();
          debugPrint('[Pixabay] After deduplication: ${deduped.length}');

          final checks = await Future.wait(
            deduped.map(_isUsableImageUrl),
            eagerError: false,
          );
          final validated = <String>[
            for (var i = 0; i < deduped.length; i++)
              if (checks[i]) deduped[i],
          ];
          debugPrint('[Pixabay] After validation: ${validated.length}');
          debugPrint('[Pixabay] Valid image URLs: ${validated.length}');
          return validated.take(limit).toList();
        }
      } else {
        debugPrint('[Pixabay] Error response: ${_safeResponseMessage(response.body)}');
      }
    } catch (e) {
      debugPrint('[Pixabay] Request failed: $e');
    }
    return [];
  }

  static bool _isRelevantUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasAuthority && !url.toLowerCase().contains('.svg');
  }

  static String _normalizeUrl(String url) => url.split('?').first.toLowerCase();

  static Future<bool> _isUsableImageUrl(String url) async {
    try {
      final response = await http
          .head(Uri.parse(url), headers: {'User-Agent': _userAgent})
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 405) return true;
      if (response.statusCode != 200) return false;
      final contentType = response.headers['content-type'] ?? '';
      return contentType.isEmpty || contentType.startsWith('image/');
    } catch (_) {
      // A transient validation failure should not discard a valid CDN URL.
      return true;
    }
  }

  static String _safeResponseMessage(String body) {
    try {
      final data = json.decode(body);
      if (data is Map<String, dynamic>) {
        final error = data['error'];
        if (error is String) return error;
        if (error is Map<String, dynamic>) {
          return (error['message'] as String?) ?? 'Unknown API error';
        }
      }
    } catch (_) {}
    return body.substring(0, body.length.clamp(0, 200));
  }

  /// Fetches the single best image URL for a given [query].
  Future<String?> getImageUrl(String query) async {
    if (_urlCache.containsKey(query)) return _urlCache[query];
    if (_failedQueries.contains(query)) return null;

    final urls = await getImageUrls(query, limit: 3);
    if (urls.isNotEmpty) {
      _urlCache[query] = urls.first;
      return urls.first;
    }
    _failedQueries.add(query);
    return null;
  }
}
