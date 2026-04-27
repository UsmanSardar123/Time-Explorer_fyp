import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/admin/data/models/character_model.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character_category.dart';

class PersonalityProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;

  PersonalityProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  List<Character> _personalities = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Character> get personalities {
    if (_searchQuery.isEmpty) return _personalities;
    final query = _searchQuery.toLowerCase();
    return _personalities.where((p) => 
      p.name.toLowerCase().contains(query) || 
      p.description.toLowerCase().contains(query)
    ).toList();
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
    if (_personalities.isNotEmpty && !_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _firestore.collection('characters').orderBy('name').get();
      
      _personalities = querySnapshot.docs.map((doc) {
        return CharacterModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error loading personalities: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Stream<List<Character>> personalitiesStream() {
    return _firestore.collection('characters').orderBy('name').snapshots().map((snap) {
      return snap.docs.map((doc) => CharacterModel.fromMap(doc.data(), doc.id)).toList();
    });
  }
}
