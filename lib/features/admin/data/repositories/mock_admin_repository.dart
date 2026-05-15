import 'package:timeexplorer/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/admin/data/models/character_model.dart';
import 'package:timeexplorer/features/admin/data/models/event_model.dart';
import 'package:timeexplorer/features/admin/domain/repositories/admin_repository.dart';
import 'package:timeexplorer/features/event_explorer/domain/entities/historical_event.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/learn/data/models/fact_model.dart';

class MockAdminRepository implements AdminRepository {
  @override
  Stream<AdminStatsEntity> getAdminStats() {
    return Stream.periodic(const Duration(seconds: 5), (_) => AdminStatsEntity(
      totalUsers: 12450,
      totalPlaces: 342,
      totalHistoricalFacts: 1890,
      totalCharacters: 58,
      totalEvents: 0,
      totalCivilizations: 0,
      totalActiveSessions: 420,
    ));
  }

  @override
  Future<void> triggerBackup() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> clearSystemCache() async {
     await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<ProfileEntity>> getAllUsers() async => [];

  @override
  Future<void> createUser(ProfileEntity user) async {}

  @override
  Future<void> updateUser(ProfileEntity user) async {}

  @override
  Future<void> deleteUser(String userId) async {}

  @override
  Future<List<ProfileEntity>> searchUsers(String query) async => [];

  // Places stubs
  @override
  Future<List<Place>> getAllPlaces() async => [];

  @override
  Future<void> createPlace(PlaceModel place) async {}

  @override
  Future<void> updatePlace(PlaceModel place) async {}

  @override
  Future<void> deletePlace(String placeId) async {}

  // Facts stubs
  @override
  Future<List<FactModel>> getAllFacts() async => [];

  @override
  Future<void> createFact(FactModel fact) async {}

  @override
  Future<void> updateFact(FactModel fact) async {}

  @override
  Future<void> deleteFact(String factId) async {}

  // Characters stubs
  @override
  Future<List<Character>> getAllCharacters() async => [];

  @override
  Future<void> createCharacter(CharacterModel character) async {}

  @override
  Future<void> updateCharacter(CharacterModel character) async {}

  @override
  Future<void> deleteCharacter(String characterId) async {}

  // Events stubs
  @override
  Future<List<HistoricalEvent>> getAllEvents() async => [];

  @override
  Future<void> createEvent(EventModel event) async {}

  @override
  Future<void> updateEvent(EventModel event) async {}

  @override
  Future<void> deleteEvent(String eventId) async {}

  // Civilizations stubs
  @override
  Future<List<Map<String, dynamic>>> getAllCivilizations() async => [];

  @override
  Future<void> deleteCivilization(String id) async {}
}
