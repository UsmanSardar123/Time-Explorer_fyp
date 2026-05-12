import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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

  @override
  Future<List<PlaceModel>> fetchAllPlaces() async {
    try {
      final querySnapshot = await _firestore.collection('places').get();
      return querySnapshot.docs
          .map((doc) => PlaceModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('[PlacesDataSource] Error fetching all places: $e');
      return [];
    }
  }

  @override
  Future<PlaceModel?> fetchPlaceById(String id) async {
    try {
      final doc = await _firestore.collection('places').doc(id).get();
      if (!doc.exists) return null;
      return PlaceModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      debugPrint('[PlacesDataSource] Error fetching place by id: $e');
      return null;
    }
  }

  @override
  Future<List<TimelineEvent>> fetchTimeline(String placeId) async {
    try {
      final querySnapshot = await _firestore.collection('places')
          .doc(placeId)
          .collection('timeline')
          .orderBy('orderIndex')
          .get();
      
      return querySnapshot.docs
          .map((doc) => TimelineEvent.fromMap(doc.data()))
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
      // Firestore 'whereIn' limits to 10 items
      final limitedIds = ids.take(10).toList();
      final querySnapshot = await _firestore.collection('places')
          .where(FieldPath.documentId, whereIn: limitedIds)
          .get();
      
      return querySnapshot.docs
          .map((doc) => PlaceModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('[PlacesDataSource] Error fetching nearby places by ids: $e');
      return [];
    }
  }
}
