import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';

abstract class PlacesRemoteDataSource {
  Future<PlaceModel> getPlaceDetails(String placeId);
  Future<List<PlaceModel>> getNearbyPlaces(String category, String excludeId);
  Future<List<PlaceModel>> getPlacesByEra(String eraId);
  Future<void> updatePlace(PlaceModel place);
  Future<void> deletePlace(String placeId);
}

class PlacesRemoteDataSourceImpl implements PlacesRemoteDataSource {
  final FirebaseFirestore _firestore;

  PlacesRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<PlaceModel> getPlaceDetails(String placeId) async {
    try {
      final doc = await _firestore.collection('places').doc(placeId).get();
      if (!doc.exists) throw Exception('Place not found');
      return PlaceModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to fetch place details: $e');
    }
  }

  @override
  Future<List<PlaceModel>> getNearbyPlaces(String category, String excludeId) async {
    try {
      final querySnapshot = await _firestore.collection('places')
          .where('category', isEqualTo: category)
          .limit(6)
          .get();
      
      return querySnapshot.docs
          .where((doc) => doc.id != excludeId)
          .take(5)
          .map((doc) => PlaceModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch nearby places: $e');
    }
  }

  @override
  Future<List<PlaceModel>> getPlacesByEra(String eraId) async {
    try {
      final querySnapshot = await _firestore.collection('places')
          .where('eraId', isEqualTo: eraId)
          .get();
      
      return querySnapshot.docs
          .map((doc) => PlaceModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch places by era: $e');
    }
  }

  @override
  Future<void> updatePlace(PlaceModel place) async {
    try {
      await _firestore.collection('places').doc(place.id).update(place.toMap());
    } catch (e) {
      throw Exception('Failed to update place: $e');
    }
  }

  @override
  Future<void> deletePlace(String placeId) async {
    try {
      await _firestore.collection('places').doc(placeId).delete();
    } catch (e) {
      throw Exception('Failed to delete place: $e');
    }
  }
}
