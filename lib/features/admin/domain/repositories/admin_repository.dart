import 'package:timeexplorer/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/admin/data/models/character_model.dart';
import 'package:timeexplorer/features/admin/data/models/event_model.dart';
import 'package:timeexplorer/features/event_explorer/domain/entities/historical_event.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/learn/data/models/fact_model.dart';

abstract class AdminRepository {
  Stream<AdminStatsEntity> getAdminStats();
  Future<void> triggerBackup();
  Future<void> clearSystemCache();

  // User Management
  Future<List<ProfileEntity>> getAllUsers();
  Future<void> createUser(ProfileEntity user);
  Future<void> updateUser(ProfileEntity user);
  Future<void> deleteUser(String userId);
  Future<List<ProfileEntity>> searchUsers(String query);

  // Places Management
  Future<List<Place>> getAllPlaces();
  Future<void> createPlace(PlaceModel place);
  Future<void> updatePlace(PlaceModel place);
  Future<void> deletePlace(String placeId);

  // Facts Management
  Future<List<FactModel>> getAllFacts();
  Future<void> createFact(FactModel fact);
  Future<void> updateFact(FactModel fact);
  Future<void> deleteFact(String factId);

  // Characters Management
  Future<List<Character>> getAllCharacters();
  Future<void> createCharacter(CharacterModel character);
  Future<void> updateCharacter(CharacterModel character);
  Future<void> deleteCharacter(String characterId);

  // Events Management
  Future<List<HistoricalEvent>> getAllEvents();
  Future<void> createEvent(EventModel event);
  Future<void> updateEvent(EventModel event);
  Future<void> deleteEvent(String eventId);

  // Civilizations Management
  Future<List<Map<String, dynamic>>> getAllCivilizations();
  Future<void> deleteCivilization(String id);
}
