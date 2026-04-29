import 'package:timeexplorer/features/places/data/datasources/places_remote_data_source.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/domain/entities/timeline_event.dart';
import 'package:timeexplorer/features/places/domain/repositories/places_repository.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesRemoteDataSource remoteDataSource;

  // In-memory cache for fetchAllPlaces
  List<PlaceModel>? _cachedPlaces;
  DateTime? _lastCacheTime;
  static const Duration _cacheDuration = Duration(minutes: 30);

  PlacesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Place> getPlaceDetails(String placeId) async {
    return await remoteDataSource.getPlaceDetails(placeId);
  }

  @override
  Future<List<Place>> getNearbyPlaces(String category, String excludeId) async {
    return await remoteDataSource.getNearbyPlaces(category, excludeId);
  }

  @override
  Future<List<Place>> getPlacesByEra(String eraId) async {
    return await remoteDataSource.getPlacesByEra(eraId);
  }

  @override
  Future<void> updatePlace(PlaceModel place) async {
    return await remoteDataSource.updatePlace(place);
  }

  @override
  Future<void> deletePlace(String placeId) async {
    return await remoteDataSource.deletePlace(placeId);
  }

  @override
  Future<List<Place>> fetchAllPlaces() async {
    // Check cache
    if (_cachedPlaces != null && _lastCacheTime != null) {
      if (DateTime.now().difference(_lastCacheTime!) < _cacheDuration) {
        return _cachedPlaces!;
      }
    }

    try {
      final places = await remoteDataSource.fetchAllPlaces();
      _cachedPlaces = places;
      _lastCacheTime = DateTime.now();
      return places;
    } catch (e) {
      // Offline fallback
      if (_cachedPlaces != null) return _cachedPlaces!;
      return [];
    }
  }

  @override
  Future<Place?> fetchPlaceById(String id) async {
    try {
      // Check cache first
      if (_cachedPlaces != null) {
        try {
          return _cachedPlaces!.firstWhere((p) => p.id == id);
        } catch (_) {}
      }
      return await remoteDataSource.fetchPlaceById(id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<TimelineEvent>> fetchTimeline(String placeId) async {
    try {
      return await remoteDataSource.fetchTimeline(placeId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Place>> fetchNearbyPlacesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    try {
      // If we have cached places, just filter from cache
      if (_cachedPlaces != null) {
        return _cachedPlaces!.where((p) => ids.contains(p.id)).toList();
      }
      return await remoteDataSource.fetchNearbyPlacesByIds(ids);
    } catch (e) {
      return [];
    }
  }
}
