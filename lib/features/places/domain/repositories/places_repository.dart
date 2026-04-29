import 'package:timeexplorer/features/places/data/models/place_model.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/domain/entities/timeline_event.dart';

abstract class PlacesRepository {
  Future<Place> getPlaceDetails(String placeId);
  Future<List<Place>> getNearbyPlaces(String category, String excludeId);
  Future<List<Place>> getPlacesByEra(String eraId);
  Future<void> updatePlace(PlaceModel place);
  Future<void> deletePlace(String placeId);
  
  // Sprint 1 Additions
  Future<List<Place>> fetchAllPlaces();
  Future<Place?> fetchPlaceById(String id);
  Future<List<TimelineEvent>> fetchTimeline(String placeId);
  Future<List<Place>> fetchNearbyPlacesByIds(List<String> ids);
}
