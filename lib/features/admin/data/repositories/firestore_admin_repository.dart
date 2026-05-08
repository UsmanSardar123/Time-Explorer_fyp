import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeexplorer/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/admin/data/models/character_model.dart';
import 'package:timeexplorer/features/admin/domain/repositories/admin_repository.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/admin/data/models/event_model.dart';
import 'package:timeexplorer/features/event_explorer/domain/entities/historical_event.dart';
import 'package:timeexplorer/features/learn/data/models/fact_model.dart';

class FirestoreAdminRepository implements AdminRepository {
  final FirebaseFirestore _firestore;

  FirestoreAdminRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<AdminStatsEntity> _fetchStats() async {
    try {
      final results = await Future.wait([
        _firestore.collection('users').count().get(),
        _firestore.collection('places').count().get(),
        _firestore.collection('facts').count().get(),
        _firestore.collection('characters').count().get(),
        _firestore.collection('events').count().get(),
      ]);
      return AdminStatsEntity(
        totalUsers:           results[0].count ?? 0,
        totalPlaces:          results[1].count ?? 0,
        totalHistoricalFacts: results[2].count ?? 0,
        totalCharacters:      results[3].count ?? 0,
        totalEvents:          results[4].count ?? 0,
        totalActiveSessions:  1,
      );
    } catch (_) {
      return AdminStatsEntity.initial();
    }
  }

  @override
  Stream<AdminStatsEntity> getAdminStats() async* {
    yield await _fetchStats();
    while (true) {
      await Future.delayed(const Duration(seconds: 30));
      yield await _fetchStats();
    }
  }

  @override
  Future<List<ProfileEntity>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) {
        final json = doc.data();
        return ProfileEntity(
          id: doc.id,
          email: json['email'] ?? '',
          displayName: json['displayName'] ?? '',
          username: json['username'],
          photoUrl: json['photoUrl'],
          bio: json['bio'],
          dob: json['dob'],
          phoneNumber: json['phoneNumber'],
          address: json['address'],
          gender: json['gender'],
          privacySettings: json['privacySettings']?.toString(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  @override
  Future<void> createUser(ProfileEntity user) async {
    try {
      final docRef = user.id.isEmpty 
          ? _firestore.collection('users').doc() 
          : _firestore.collection('users').doc(user.id);
      await docRef.set({
        'id': docRef.id,
        'email': user.email,
        'displayName': user.displayName,
        'username': user.username,
        'photoUrl': user.photoUrl,
        'bio': user.bio,
        'dob': user.dob,
        'phoneNumber': user.phoneNumber,
        'address': user.address,
        'gender': user.gender,
        'privacySettings': user.privacySettings,
      });
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<void> updateUser(ProfileEntity user) async {
    try {
      await _firestore.collection('users').doc(user.id).update({
        'email': user.email,
        'displayName': user.displayName,
        'username': user.username,
        'photoUrl': user.photoUrl,
        'bio': user.bio,
        'dob': user.dob,
        'phoneNumber': user.phoneNumber,
        'address': user.address,
        'gender': user.gender,
        'privacySettings': user.privacySettings,
      });
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  @override
  Future<List<ProfileEntity>> searchUsers(String query) async {
    try {
      final querySnapshot = await _firestore.collection('users')
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
      return querySnapshot.docs.map((doc) {
        final json = doc.data();
        return ProfileEntity(
          id: doc.id,
          email: json['email'] ?? '',
          displayName: json['displayName'] ?? '',
          username: json['username'],
          photoUrl: json['photoUrl'],
          bio: json['bio'],
          dob: json['dob'],
          phoneNumber: json['phoneNumber'],
          address: json['address'],
          gender: json['gender'],
          privacySettings: json['privacySettings']?.toString(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  @override
  Future<void> triggerBackup() async {
    // Mock backup
  }

  @override
  Future<void> clearSystemCache() async {
    // Mock clearing cache
  }

  // ── Places Management ──────────────────────────────────────────────────────

  @override
  Future<List<Place>> getAllPlaces() async {
    try {
      final querySnapshot = await _firestore.collection('places').get();
      return querySnapshot.docs.map((doc) => PlaceModel.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch places: $e');
    }
  }

  @override
  Future<void> createPlace(PlaceModel place) async {
    try {
      final docRef = place.id.isEmpty 
          ? _firestore.collection('places').doc() 
          : _firestore.collection('places').doc(place.id);
      await docRef.set({...place.toMap(), 'id': docRef.id});
    } catch (e) {
      throw Exception('Failed to create place: $e');
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

  // ── Facts Management ──────────────────────────────────────────────────────

  @override
  Future<List<FactModel>> getAllFacts() async {
    try {
      final querySnapshot = await _firestore.collection('facts').get();
      return querySnapshot.docs.map((doc) => FactModel.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch facts: $e');
    }
  }

  @override
  Future<void> createFact(FactModel fact) async {
    try {
      final docRef = fact.id.isEmpty 
          ? _firestore.collection('facts').doc() 
          : _firestore.collection('facts').doc(fact.id);
      await docRef.set({...fact.toMap(), 'id': docRef.id});
    } catch (e) {
      throw Exception('Failed to create fact: $e');
    }
  }

  @override
  Future<void> updateFact(FactModel fact) async {
    try {
      await _firestore.collection('facts').doc(fact.id).update(fact.toMap());
    } catch (e) {
      throw Exception('Failed to update fact: $e');
    }
  }

  @override
  Future<void> deleteFact(String factId) async {
    try {
      await _firestore.collection('facts').doc(factId).delete();
    } catch (e) {
      throw Exception('Failed to delete fact: $e');
    }
  }

  // ── Characters Management ─────────────────────────────────────────────────

  @override
  Future<List<Character>> getAllCharacters() async {
    try {
      final snap = await _firestore.collection('characters').orderBy('name').get();
      return snap.docs.map((d) => CharacterModel.fromMap(d.data(), d.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch characters: $e');
    }
  }

  @override
  Future<void> createCharacter(CharacterModel character) async {
    try {
      final ref = character.id.isEmpty 
          ? _firestore.collection('characters').doc() 
          : _firestore.collection('characters').doc(character.id);
      await ref.set({...character.toMap(), 'id': ref.id});
    } catch (e) {
      throw Exception('Failed to create character: $e');
    }
  }

  @override
  Future<void> updateCharacter(CharacterModel character) async {
    try {
      await _firestore.collection('characters').doc(character.id).update(character.toMap());
    } catch (e) {
      throw Exception('Failed to update character: $e');
    }
  }

  @override
  Future<void> deleteCharacter(String characterId) async {
    try {
      await _firestore.collection('characters').doc(characterId).delete();
    } catch (e) {
      throw Exception('Failed to delete character: $e');
    }
  }

  // ── Events Management ──────────────────────────────────────────────────────

  @override
  Future<List<HistoricalEvent>> getAllEvents() async {
    try {
      final snap = await _firestore.collection('events').orderBy('title').get();
      return snap.docs.map((d) => EventModel.fromMap(d.data(), d.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  @override
  Future<void> createEvent(EventModel event) async {
    try {
      final ref = event.id.isEmpty 
          ? _firestore.collection('events').doc() 
          : _firestore.collection('events').doc(event.id);
      await ref.set({...event.toMap(), 'id': ref.id});
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    try {
      await _firestore.collection('events').doc(event.id).update(event.toMap());
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}
