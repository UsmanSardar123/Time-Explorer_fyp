// FILE: lib/features/places/data/services/place_image_service.dart
// PURPOSE: Fetches place images via Gemini-expanded queries against Wikimedia Commons.
// FEATURE: Photo Gallery

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:timeexplorer/core/config/app_config.dart';

class PlaceImageService {
  static const String _wikimediaBase =
      'https://commons.wikimedia.org/w/api.php';
  static const int _thumbWidth = 800;
  static const int _perQueryLimit = 5;
  static const int _maxImages = 10;
  static const String _geminiModel = 'gemini-1.5-flash-latest';

  static final Map<String, List<String>> _cache = {};

  static Future<List<String>> fetchImages(String placeName) async {
    if (_cache.containsKey(placeName)) return _cache[placeName]!;

    final queries = await _geminiExpandQueries(placeName);
    List<String> urls;

    if (queries.isNotEmpty) {
      urls = await _fetchMultiQuery(queries);
    } else {
      urls = await _directFallback(placeName);
    }

    _cache[placeName] = urls;
    return urls;
  }

  static Future<List<String>> _geminiExpandQueries(String placeName) async {
    try {
      final apiKey = AppConfig.geminiApiKey;
      if (apiKey.isEmpty) return [];

      final model = GenerativeModel(model: _geminiModel, apiKey: apiKey);
      final prompt =
          'You are a photo search assistant. Given a place name, return exactly '
          '4 short image search queries for Wikimedia Commons that would find '
          'different high-quality photos (e.g. exterior, interior, aerial, '
          'detail view). Return ONLY the 4 queries, one per line, no numbering, '
          'no extra text.\nPlace: $placeName';

      final response = await model
          .generateContent([Content.text(prompt)]).timeout(
              const Duration(seconds: 12));

      final text = response.text ?? '';
      final queries = text
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty && l.length > 3)
          .take(4)
          .toList();

      return queries;
    } catch (e) {
      debugPrint('[PlaceImageService] Gemini expansion failed: $e');
      return [];
    }
  }

  static Future<List<String>> _fetchMultiQuery(List<String> queries) async {
    final results = await Future.wait(
      queries.map((q) => _query(q)),
      eagerError: false,
    );

    final seen = <String>{};
    final merged = <String>[];
    for (final batch in results) {
      for (final url in batch) {
        if (seen.add(url) && merged.length < _maxImages) {
          merged.add(url);
        }
      }
    }
    return merged;
  }

  static Future<List<String>> _directFallback(String placeName) async {
    var urls = await _query(placeName);
    if (urls.isEmpty) {
      final shortened = placeName.split(RegExp(r'[,\-–]')).first.trim();
      if (shortened != placeName) urls = await _query(shortened);
    }
    if (urls.isEmpty) {
      final firstWord = placeName.split(' ').first;
      if (firstWord != placeName) urls = await _query(firstWord);
    }
    return urls;
  }

  static Future<List<String>> _query(String query) async {
    try {
      final uri = Uri.parse(_wikimediaBase).replace(queryParameters: {
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

      final response =
          await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return [];

      final data = json.decode(response.body) as Map<String, dynamic>;
      final pages = data['query']?['pages'] as Map<String, dynamic>?;
      if (pages == null) return [];

      final urls = <String>[];
      for (final page in pages.values) {
        final infoList = page['imageinfo'] as List?;
        if (infoList == null || infoList.isEmpty) continue;
        final info = infoList[0] as Map<String, dynamic>;
        final mime = (info['mime'] as String? ?? '').toLowerCase();
        final thumb = info['thumburl'] as String?;
        final full = info['url'] as String?;
        final url = (thumb?.isNotEmpty == true ? thumb : full) ?? '';
        if (url.isNotEmpty && _isValidMime(mime, url)) {
          urls.add(url);
        }
      }
      return urls;
    } catch (_) {
      return [];
    }
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

  static void clearCache() => _cache.clear();
}
