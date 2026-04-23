import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:timeexplorer/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:timeexplorer/features/admin/domain/entities/character_entity.dart';
import 'package:timeexplorer/features/admin/data/models/character_model.dart';
import 'package:timeexplorer/features/admin/domain/repositories/admin_repository.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/learn/data/models/fact_model.dart';
import 'package:timeexplorer/features/learn/data/facts_data.dart';

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
  List<CharacterEntity> _characters = [];
  bool _isCharactersLoading = false;
  String? _charactersError;

  List<CharacterEntity> get characters => _characters;
  bool get isCharactersLoading => _isCharactersLoading;
  String? get charactersError => _charactersError;

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
          fact: rawFact['fact'] ?? '',
          category: rawFact['category'] ?? 'General',
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

  // ── System ───────────────────────────────────────────────────────────────

  Future<void> triggerBackup() async {
    await _repository.triggerBackup();
  }

  Future<void> clearSystemCache() async {
    await _repository.clearSystemCache();
  }
}
