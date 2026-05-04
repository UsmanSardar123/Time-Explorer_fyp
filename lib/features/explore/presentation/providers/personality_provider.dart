import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/admin/data/models/character_model.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character_category.dart';
import 'package:timeexplorer/features/personalities/data/datasources/character_local_data_source.dart';

class PersonalityProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;

  PersonalityProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  List<Character> _personalities = [];
  bool _isLoading = false;
  bool _hasLoaded = false;
  String _searchQuery = '';

  List<Character> get personalities {
    if (_searchQuery.isEmpty) return _personalities;
    final query = _searchQuery.toLowerCase();
    return _personalities.where((p) =>
        p.name.toLowerCase().contains(query) ||
        p.description.toLowerCase().contains(query)).toList();
  }

  List<Character> getCharactersByCategory(CharacterCategory category) {
    return _personalities.where((p) => p.category == category).toList();
  }

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadPersonalities() async {
    if (_hasLoaded) return; // Guard: already loaded this session.
    if (_isLoading) return; // Guard: fetch already in flight.

    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('[PersonalityProvider] Fetching characters from Firestore...');
      final querySnapshot =
          await _firestore.collection('characters').orderBy('name').get();

      if (querySnapshot.docs.isNotEmpty) {
        _personalities = querySnapshot.docs
            .map((doc) => CharacterModel.fromMap(doc.data(), doc.id))
            .toList();
        debugPrint(
            '[PersonalityProvider] Loaded ${_personalities.length} characters from Firestore.');
      } else {
        debugPrint(
            '[PersonalityProvider] Firestore empty — using local character data.');
        _personalities = CharacterLocalDataSource.allCharacters;
      }
      _hasLoaded = true;
    } catch (e) {
      debugPrint(
          '[PersonalityProvider] Firestore error: $e — falling back to local data.');
      if (_personalities.isEmpty) {
        _personalities = CharacterLocalDataSource.allCharacters;
      }
      // Do not set _hasLoaded on error — allow retry via refresh().
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _hasLoaded = false;
    await loadPersonalities();
  }

  Stream<List<Character>> personalitiesStream() {
    return _firestore
        .collection('characters')
        .orderBy('name')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => CharacterModel.fromMap(doc.data(), doc.id)).toList());
  }
}
