import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PixabayService {
  static const String _baseUrl = 'https://pixabay.com/api/';
  static const String _apiKey = '53527064-edf2dfe298a58b020b583beec';

  // In-memory cache to prevent redundant API calls
  static final Map<String, String> _urlCache = {};
  // Track queries that failed to find an image to avoid redundant calls
  static final Set<String> _failedQueries = {};

  /// Fetches a list of image URLs for a given [query].
  Future<List<String>> getImageUrls(String query, {int limit = 5}) async {
    try {
      final uri = Uri.parse(_baseUrl).replace(queryParameters: {
        'key': _apiKey,
        'q': query,
        'image_type': 'photo',
        'per_page': limit.toString(),
        'safesearch': 'true',
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final hits = data['hits'] as List<dynamic>;

        if (hits.isNotEmpty) {
          final urls = hits
              .map((hit) =>
                  (hit['largeImageURL'] as String? ??
                   hit['webformatURL'] as String? ?? ''))
              .where((u) => u.isNotEmpty)
              .toList();
          debugPrint('[PixabayService] ✅ ${urls.length} images for "$query"');
          return urls;
        }
      }
    } catch (e) {
      debugPrint('[PixabayService] ❌ error for "$query": $e');
    }
    return [];
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
