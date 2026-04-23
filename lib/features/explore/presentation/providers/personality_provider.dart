import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeexplorer/features/explore/domain/entities/personality_entity.dart';

class PersonalityProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;

  PersonalityProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  List<PersonalityEntity> _personalities = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<PersonalityEntity> get personalities {
    if (_searchQuery.isEmpty) return _personalities;
    final query = _searchQuery.toLowerCase();
    return _personalities.where((p) => 
      p.name.toLowerCase().contains(query) || 
      p.description.toLowerCase().contains(query)
    ).toList();
  }
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadPersonalities() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _firestore.collection('personalities').get();
      
      _personalities = querySnapshot.docs.map((doc) {
        final json = doc.data();
        return PersonalityEntity(
          id: doc.id,
          name: json['name'] ?? '',
          description: json['description'] ?? '',
          imageUrl: json['imageUrl'] ?? '',
          era: json['era'] ?? '',
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading personalities: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
