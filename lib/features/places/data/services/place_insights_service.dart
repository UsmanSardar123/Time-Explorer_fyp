// FILE: lib/features/places/data/services/place_insights_service.dart
// PURPOSE: Fetches AI-generated insights for a place via backend API, with in-memory 7-day cache.

import 'package:flutter/foundation.dart';
import 'package:timeexplorer/core/services/api_service.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';

class PlaceInsightsService {
  static final Map<String, _InsightCacheEntry> _cache = {};

  PlaceInsightsService();

  Future<List<String>> getInsights(Place place) async {
    final cacheKey = place.aiInsightsCacheKey ?? place.id;
    final cached = _cache[cacheKey];
    if (cached != null && !cached.isExpired) return cached.insights;

    try {
      return await _fetchFromApi(place, cacheKey);
    } catch (e) {
      debugPrint('[PlaceInsightsService] Failed for ${place.id}: $e');
      return cached?.insights ?? [];
    }
  }

  Future<List<String>> _fetchFromApi(Place place, String cacheKey) async {
    final prompt =
        'Give me exactly 3 surprising, lesser-known facts about ${place.name} '
        'in ${place.country ?? place.location}. Each fact must be historically accurate, '
        'max 25 words, and begin with a number (1., 2., 3.). '
        'Return only the 3 facts, no intro text.';

    final api = ApiService();
    final data = await api.post('/ai/ask', {'prompt': prompt});
    final text = (data['response'] as String? ?? '').trim();
    final facts = _parseFacts(text);
    if (facts.isNotEmpty) _cache[cacheKey] = _InsightCacheEntry(facts);
    return facts;
  }

  List<String> _parseFacts(String text) {
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final facts = <String>[];
    for (final line in lines) {
      final cleaned = line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();
      if (cleaned.isNotEmpty) facts.add(cleaned);
      if (facts.length == 3) break;
    }
    return facts;
  }
}

class _InsightCacheEntry {
  final List<String> insights;
  final DateTime _createdAt;

  _InsightCacheEntry(this.insights) : _createdAt = DateTime.now();

  bool get isExpired => DateTime.now().difference(_createdAt).inDays >= 7;
}
