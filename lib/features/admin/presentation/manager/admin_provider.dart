import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:timeexplorer/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:timeexplorer/features/admin/data/models/character_model.dart';
import 'package:timeexplorer/features/admin/domain/repositories/admin_repository.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/learn/data/models/fact_model.dart';
import 'package:timeexplorer/features/learn/data/facts_data.dart';
import 'package:timeexplorer/features/personalities/data/datasources/character_local_data_source.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/admin/data/models/event_model.dart';
import 'package:timeexplorer/features/event_explorer/domain/entities/historical_event.dart';
import 'package:timeexplorer/features/places/data/datasources/wikimedia_image_service.dart';

class AdminProvider with ChangeNotifier {
  final AdminRepository _repository;
  StreamSubscription<AdminStatsEntity>? _statsSubscription;

  AdminProvider({required AdminRepository repository}) : _repository = repository;

  @override
  void dispose() {
    _statsSubscription?.cancel();
    super.dispose();
  }

  // Stats State
  AdminStatsEntity? _stats;
  bool _isLoading = false;
  String? _error;

  AdminStatsEntity? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Users State
  List<ProfileEntity> _users = [];
  bool _isUsersLoading = false;
  String? _usersError;

  List<ProfileEntity> get users => _users;
  bool get isUsersLoading => _isUsersLoading;
  String? get usersError => _usersError;

  // Places State
  List<Place> _places = [];
  bool _isPlacesLoading = false;
  String? _placesError;

  List<Place> get places => _places;
  bool get isPlacesLoading => _isPlacesLoading;
  String? get placesError => _placesError;

  // Facts State
  List<FactModel> _facts = [];
  bool _isFactsLoading = false;
  String? _factsError;

  List<FactModel> get facts => _facts;
  bool get isFactsLoading => _isFactsLoading;
  String? get factsError => _factsError;

  // Characters State
  List<Character> _characters = [];
  bool _isCharactersLoading = false;
  String? _charactersError;

  List<Character> get characters => _characters;
  bool get isCharactersLoading => _isCharactersLoading;
  String? get charactersError => _charactersError;

  // Events State
  List<HistoricalEvent> _events = [];
  bool _isEventsLoading = false;
  String? _eventsError;

  List<HistoricalEvent> get events => _events;
  bool get isEventsLoading => _isEventsLoading;
  String? get eventsError => _eventsError;

  Future<void> loadStats() async {
    await _statsSubscription?.cancel();

    _isLoading = true;
    _error = null;
    notifyListeners();

    _statsSubscription = _repository.getAdminStats().listen(
      (newStats) {
        _stats = newStats;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // ── User Management ──────────────────────────────────────────────────────

  Future<void> fetchUsers() async {
    _isUsersLoading = true;
    _usersError = null;
    notifyListeners();

    try {
      _users = await _repository.getAllUsers();
    } catch (e) {
      _usersError = e.toString();
    } finally {
      _isUsersLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      return fetchUsers();
    }

    _isUsersLoading = true;
    _usersError = null;
    notifyListeners();

    try {
      _users = await _repository.searchUsers(query);
    } catch (e) {
      _usersError = e.toString();
    } finally {
      _isUsersLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(ProfileEntity user) async {
    _isUsersLoading = true;
    _usersError = null;
    notifyListeners();

    try {
      await _repository.createUser(user);
      await fetchUsers();
    } catch (e) {
      _usersError = e.toString();
    } finally {
      _isUsersLoading = false;
      notifyListeners();
    }
  }

  Future<void> editUser(ProfileEntity user) async {
    _isUsersLoading = true;
    _usersError = null;
    notifyListeners();

    try {
      await _repository.updateUser(user);
      await fetchUsers();
    } catch (e) {
      _usersError = e.toString();
    } finally {
      _isUsersLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeUser(String userId) async {
    _isUsersLoading = true;
    _usersError = null;
    notifyListeners();

    try {
      await _repository.deleteUser(userId);
      _users.removeWhere((u) => u.id == userId);
    } catch (e) {
      _usersError = e.toString();
    } finally {
      _isUsersLoading = false;
      notifyListeners();
    }
  }

  // ── Places Management ────────────────────────────────────────────────────

  Future<void> fetchPlaces() async {
    _isPlacesLoading = true;
    _placesError = null;
    notifyListeners();

    try {
      _places = await _repository.getAllPlaces();
    } catch (e) {
      _placesError = e.toString();
    } finally {
      _isPlacesLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPlace(PlaceModel place) async {
    _isPlacesLoading = true;
    _placesError = null;
    notifyListeners();

    try {
      await _repository.createPlace(place);
      await fetchPlaces();
    } catch (e) {
      _placesError = e.toString();
    } finally {
      _isPlacesLoading = false;
      notifyListeners();
    }
  }

  Future<void> editPlace(PlaceModel place) async {
    _isPlacesLoading = true;
    _placesError = null;
    notifyListeners();

    try {
      await _repository.updatePlace(place);
      await fetchPlaces();
    } catch (e) {
      _placesError = e.toString();
    } finally {
      _isPlacesLoading = false;
      notifyListeners();
    }
  }

  Future<void> removePlace(String placeId) async {
    _isPlacesLoading = true;
    _placesError = null;
    notifyListeners();

    try {
      await _repository.deletePlace(placeId);
      _places.removeWhere((p) => p.id == placeId);
    } catch (e) {
      _placesError = e.toString();
    } finally {
      _isPlacesLoading = false;
      notifyListeners();
    }
  }

  // ── Facts Management ──────────────────────────────────────────────────────

  Future<void> fixLegacyPlaceImages() async {
    _isPlacesLoading = true;
    _placesError = null;
    notifyListeners();

    try {
      if (_places.isEmpty) {
        await fetchPlaces();
      }

      int updatedCount = 0;
      for (final place in _places) {
        final currentUrl = place.imageUrl;
        final needsFix = currentUrl.isEmpty || 
                         currentUrl.contains('unsplash.com') || 
                         currentUrl.contains('assets/') ||
                         currentUrl.contains('placeholder');

        if (needsFix) {
          final newUrl = await WikimediaImageService.fetchPlaceImageUrl(place.name);
          if (newUrl != null && newUrl.isNotEmpty) {
            final updatedPlace = PlaceModel(
              id: place.id,
              name: place.name,
              category: place.category,
              location: place.location,
              description: place.description,
              imageUrl: newUrl,
              rating: place.rating,
              eraId: place.eraId,
              history: place.history,
              country: place.country,
              civilization: place.civilization,
              builtBy: place.builtBy,
              constructionDate: place.constructionDate,
              architecturalStyle: place.architecturalStyle,
              historicalSignificance: place.historicalSignificance,
              funFacts: place.funFacts,
              visitorInfo: place.visitorInfo,
              createdAt: place.createdAt,
              images: place.images,
              keyFacts: place.keyFacts,
              openingHours: place.openingHours,
              ticketPrice: place.ticketPrice,
              bestTimeToVisit: place.bestTimeToVisit,
              visitDuration: place.visitDuration,
              didYouKnow: place.didYouKnow,
              latitude: place.latitude,
              longitude: place.longitude,
              era: place.era,
              significance: place.significance,
              facts: place.facts,
              timeline: place.timeline,
              quizzes: place.quizzes,
            );
            await _repository.updatePlace(updatedPlace);
            updatedCount++;
          }
        }
      }

      if (updatedCount > 0) {
        await fetchPlaces(); // Refresh list after updates
      }
    } catch (e) {
      _placesError = 'Failed to fix legacy images: $e';
    } finally {
      _isPlacesLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFacts() async {
    _isFactsLoading = true;
    _factsError = null;
    notifyListeners();

    try {
      _facts = await _repository.getAllFacts();
    } catch (e) {
      _factsError = e.toString();
    } finally {
      _isFactsLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFact(FactModel fact) async {
    _isFactsLoading = true;
    _factsError = null;
    notifyListeners();

    try {
      await _repository.createFact(fact);
      await fetchFacts();
    } catch (e) {
      _factsError = e.toString();
    } finally {
      _isFactsLoading = false;
      notifyListeners();
    }
  }

  Future<void> editFact(FactModel fact) async {
    _isFactsLoading = true;
    _factsError = null;
    notifyListeners();

    try {
      await _repository.updateFact(fact);
      await fetchFacts();
    } catch (e) {
      _factsError = e.toString();
    } finally {
      _isFactsLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeFact(String factId) async {
    _isFactsLoading = true;
    _factsError = null;
    notifyListeners();

    try {
      await _repository.deleteFact(factId);
      _facts.removeWhere((f) => f.id == factId);
    } catch (e) {
      _factsError = e.toString();
    } finally {
      _isFactsLoading = false;
      notifyListeners();
    }
  }

  Future<void> seedFactsFromLocal() async {
    _isFactsLoading = true;
    _factsError = null;
    notifyListeners();

    try {
      for (final rawFact in historicalFacts) {
        final newFact = FactModel(
          id: '',
          title: rawFact['fact']?.split('.').first ?? 'Fact',
          description: rawFact['fact'] ?? '',
          category: rawFact['category'] ?? 'General',
          type: 'general',
        );
        await _repository.createFact(newFact);
      }
      await fetchFacts();
    } catch (e) {
      _factsError = e.toString();
    } finally {
      _isFactsLoading = false;
      notifyListeners();
    }
  }

  Future<void> migrateAllData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Migrate Facts from historicalFacts
      await seedFactsFromLocal();

      // 2. Migrate Characters from CharacterLocalDataSource
      final localCharacters = CharacterLocalDataSource.allCharacters;

      for (final char in localCharacters) {
        final charModel = CharacterModel(
          id: char.id,
          name: char.name,
          category: char.category, // Fixed: passing enum directly
          era: char.era,
          description: char.description,
          imageUrl: char.imageUrl,
          title: char.title,
          dob: char.dob,
          dod: char.dod,
          origin: char.origin,
          nationality: char.origin,
          achievements: char.contributions,
          bio: char.bio,
          chatPrompt: char.chatPrompt,
          tone: char.tone,
          communicationStyle: char.communicationStyle,
          domainKnowledge: char.domainKnowledge,
          specialties: char.specialties,
          quiz: char.quiz, // Fixed: passing List<QuizQuestion> directly
          contributions: char.contributions,
          facts: char.facts,
        );
        await _repository.createCharacter(charModel);

        // 3. Migrate Character Facts to separate collection
        for (final factStr in char.facts) {
          final factModel = FactModel(
            id: '',
            title: '${char.name} Fact',
            description: factStr,
            relatedEntityId: char.id,
            type: 'character',
            category: char.category.name,
          );
          await _repository.createFact(factModel);
        }
      }

      await loadStats();
      await fetchCharacters();
      await fetchFacts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Characters Management ─────────────────────────────────────────────────

  Future<void> fetchCharacters() async {
    _isCharactersLoading = true;
    _charactersError = null;
    notifyListeners();
    try {
      _characters = await _repository.getAllCharacters();
    } catch (e) {
      _charactersError = e.toString();
    } finally {
      _isCharactersLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCharacter(CharacterModel character) async {
    _isCharactersLoading = true;
    _charactersError = null;
    notifyListeners();
    try {
      await _repository.createCharacter(character);
      await fetchCharacters();
    } catch (e) {
      _charactersError = e.toString();
    } finally {
      _isCharactersLoading = false;
      notifyListeners();
    }
  }

  Future<void> editCharacter(CharacterModel character) async {
    _isCharactersLoading = true;
    _charactersError = null;
    notifyListeners();
    try {
      await _repository.updateCharacter(character);
      await fetchCharacters();
    } catch (e) {
      _charactersError = e.toString();
    } finally {
      _isCharactersLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeCharacter(String id) async {
    _isCharactersLoading = true;
    _charactersError = null;
    notifyListeners();
    try {
      await _repository.deleteCharacter(id);
      _characters.removeWhere((c) => c.id == id);
    } catch (e) {
      _charactersError = e.toString();
    } finally {
      _isCharactersLoading = false;
      notifyListeners();
    }
  }

  // ── Events Management ─────────────────────────────────────────────────────

  Future<void> fetchEvents() async {
    _isEventsLoading = true;
    _eventsError = null;
    notifyListeners();
    try {
      _events = await _repository.getAllEvents();
    } catch (e) {
      _eventsError = e.toString();
    } finally {
      _isEventsLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEvent(EventModel event) async {
    _isEventsLoading = true;
    _eventsError = null;
    notifyListeners();
    try {
      await _repository.createEvent(event);
      await fetchEvents();
    } catch (e) {
      _eventsError = e.toString();
    } finally {
      _isEventsLoading = false;
      notifyListeners();
    }
  }

  Future<void> editEvent(EventModel event) async {
    _isEventsLoading = true;
    _eventsError = null;
    notifyListeners();
    try {
      await _repository.updateEvent(event);
      await fetchEvents();
    } catch (e) {
      _eventsError = e.toString();
    } finally {
      _isEventsLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeEvent(String id) async {
    _isEventsLoading = true;
    _eventsError = null;
    notifyListeners();
    try {
      await _repository.deleteEvent(id);
      _events.removeWhere((e) => e.id == id);
    } catch (e) {
      _eventsError = e.toString();
    } finally {
      _isEventsLoading = false;
      notifyListeners();
    }
  }

  // ── System ───────────────────────────────────────────────────────────────

  Future<void> triggerBackup() async {
    await _repository.triggerBackup();
  }

  Future<void> clearSystemCache() async {
    await _repository.clearSystemCache();
  }
}
