import 'package:timeexplorer/features/places/data/models/place_model.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';

abstract class PlacesRepository {
  Future<Place> getPlaceDetails(String placeId);
  Future<List<Place>> getNearbyPlaces(String category, String excludeId);
  Future<List<Place>> getPlacesByEra(String eraId);
  Future<void> updatePlace(PlaceModel place);
  Future<void> deletePlace(String placeId);
}
