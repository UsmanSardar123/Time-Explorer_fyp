import 'package:flutter/foundation.dart';
import 'package:timeexplorer/core/services/api_service.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';
import 'package:timeexplorer/features/places/domain/entities/timeline_event.dart';

abstract class PlacesRemoteDataSource {
  Future<PlaceModel> getPlaceDetails(String placeId);
  Future<List<PlaceModel>> getNearbyPlaces(String category, String excludeId);
  Future<List<PlaceModel>> getPlacesByEra(String eraId);
  Future<void> updatePlace(PlaceModel place);
  Future<void> deletePlace(String placeId);

  // Sprint 1 Additions
  Future<List<PlaceModel>> fetchAllPlaces();
  Future<PlaceModel?> fetchPlaceById(String id);
  Future<List<TimelineEvent>> fetchTimeline(String placeId);
  Future<List<PlaceModel>> fetchNearbyPlacesByIds(List<String> ids);
}

class PlacesRemoteDataSourceImpl implements PlacesRemoteDataSource {
  final ApiService _api;

  PlacesRemoteDataSourceImpl({ApiService? api}) : _api = api ?? ApiService();

  PlaceModel _mapToPlace(Map<String, dynamic> data) {
    final id = data['id'] as String? ?? '';
    return PlaceModel.fromMap(data, id);
  }

  Map<String, dynamic> _placeToApiBody(PlaceModel place) {
    final map = place.toMap();
    // GeoPoint is not JSON-serializable; lat/lng are stored as separate fields too
    map.remove('coordinates');
    return map;
  }

  @override
  Future<PlaceModel> getPlaceDetails(String placeId) async {
    try {
      final data = await _api.get('/places/$placeId') as Map<String, dynamic>;
      return _mapToPlace(data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch place details: $e');
    }
  }

  @override
  Future<List<PlaceModel>> getNearbyPlaces(String category, String excludeId) async {
    try {
      final raw = await _api.get('/places?category=${Uri.encodeComponent(category)}&limit=6') as List;
      return raw
          .cast<Map<String, dynamic>>()
          .where((d) => (d['id'] as String? ?? '') != excludeId)
          .take(5)
          .map(_mapToPlace)
          .toList();
    } catch (e) {
      debugPrint('[PlacesDataSource] Error fetching nearby places: $e');
      return [];
    }
  }

  @override
  Future<List<PlaceModel>> getPlacesByEra(String eraId) async {
    try {
      final raw = await _api.get('/places?eraId=${Uri.encodeComponent(eraId)}') as List;
      return raw.cast<Map<String, dynamic>>().map(_mapToPlace).toList();
    } catch (e) {
      debugPrint('[PlacesDataSource] Error fetching places by era: $e');
      return [];
    }
  }

  @override
  Future<void> updatePlace(PlaceModel place) async {
    try {
      await _api.put('/places/${place.id}', _placeToApiBody(place));
    } catch (e) {
      throw Exception('Failed to update place: $e');
    }
  }

  @override
  Future<void> deletePlace(String placeId) async {
    try {
      await _api.delete('/places/$placeId');
    } catch (e) {
      throw Exception('Failed to delete place: $e');
    }
  }

  @override
  Future<List<PlaceModel>> fetchAllPlaces() async {
    try {
      final raw = await _api.get('/places') as List;
      return raw.cast<Map<String, dynamic>>().map(_mapToPlace).toList();
    } catch (e) {
      debugPrint('[PlacesDataSource] Error fetching all places: $e');
      return [];
    }
  }

  @override
  Future<PlaceModel?> fetchPlaceById(String id) async {
    try {
      final data = await _api.get('/places/$id') as Map<String, dynamic>;
      return _mapToPlace(data);
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    } catch (e) {
      debugPrint('[PlacesDataSource] Error fetching place by id: $e');
      return null;
    }
  }

  @override
  Future<List<TimelineEvent>> fetchTimeline(String placeId) async {
    try {
      final raw = await _api.get('/places/$placeId/timeline') as List;
      return raw
          .cast<Map<String, dynamic>>()
          .map(TimelineEvent.fromMap)
          .toList();
    } catch (e) {
      debugPrint('[PlacesDataSource] Error fetching timeline: $e');
      return [];
    }
  }

  @override
  Future<List<PlaceModel>> fetchNearbyPlacesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    try {
      final limited = ids.take(10).join(',');
      final raw = await _api.get('/places?ids=${Uri.encodeComponent(limited)}') as List;
      return raw.cast<Map<String, dynamic>>().map(_mapToPlace).toList();
    } catch (e) {
      debugPrint('[PlacesDataSource] Error fetching nearby places by ids: $e');
      return [];
    }
  }
}
