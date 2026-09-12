import 'package:flutter/foundation.dart';
import 'package:timeexplorer/core/cache/hive_cache_manager.dart';
import 'package:timeexplorer/core/services/api_service.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/domain/entities/place_storyboard.dart';

class PlaceStoryboardService {
  final ApiService _api;
  static final Map<String, Future<PlaceStoryboard>> _inFlight = {};

  PlaceStoryboardService({ApiService? api}) : _api = api ?? ApiService();

  Future<PlaceStoryboard> load(Place place, {bool forceRefresh = false}) async {
    final key = CacheKeys.storyboard(place.id);
    if (!forceRefresh) {
      final cached = HiveCacheManager.get<dynamic>(key);
      if (cached is Map) {
        try {
          return PlaceStoryboard.fromMap(Map<String, dynamic>.from(cached));
        } on FormatException {
          await HiveCacheManager.invalidate(key);
        }
      }
    }

    if (!forceRefresh && _inFlight.containsKey(place.id)) {
      return _inFlight[place.id]!;
    }

    final request = _generate(place, key);
    _inFlight[place.id] = request;
    try {
      return await request;
    } finally {
      if (identical(_inFlight[place.id], request)) _inFlight.remove(place.id);
    }
  }

  Future<PlaceStoryboard> _generate(Place place, String cacheKey) async {
    final data = await _api.post('/ai/storyboard', {
      'placeId': place.id,
      'name': place.name,
      'category': place.category,
      'description': place.description,
      'location': place.location,
      'history': place.history,
      'era': place.era,
      'facts': [...?place.facts, ...?place.funFacts].take(5).toList(),
    });
    final raw = data is Map ? data['storyboard'] : null;
    if (raw is! Map) throw const FormatException('Storyboard response is missing');
    final storyboard = PlaceStoryboard.fromMap(Map<String, dynamic>.from(raw));
    await HiveCacheManager.put(cacheKey, storyboard.toMap(), CacheTtl.storyboard);
    return storyboard;
  }

  Future<void> clear(String placeId) async {
    debugPrint('[PlaceStoryboardService] Clearing storyboard cache for $placeId');
    await HiveCacheManager.invalidate(CacheKeys.storyboard(placeId));
  }
}
