// FILE: lib/features/personalities/data/repositories/character_firestore_repository.dart
// PURPOSE: Fetches Character documents from Firestore with a 30-minute in-memory cache.
// SPRINT: 1

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../admin/data/models/character_model.dart';
import '../../domain/entities/character.dart';

class CharacterFirestoreRepository {
  static const _collection = 'characters';

  final FirebaseFirestore _firestore;
  final Map<String, _CacheEntry> _cache = {};

  CharacterFirestoreRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Character?> getById(String id) async {
    final cached = _cache[id];
    if (cached != null && !cached.isExpired) return cached.character;

    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists || doc.data() == null) return null;

      final character = CharacterModel.fromMap(doc.data()!, doc.id);
      _cache[id] = _CacheEntry(character);
      return character;
    } catch (e) {
      debugPrint('[CharacterFirestoreRepo] getById($id) failed: $e');
      return cached?.character;
    }
  }

  Future<List<Character>> getAll() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final characters = snapshot.docs
          .map((doc) => CharacterModel.fromMap(doc.data(), doc.id))
          .toList();
      for (final c in characters) {
        _cache[c.id] = _CacheEntry(c);
      }
      return characters;
    } catch (e) {
      debugPrint('[CharacterFirestoreRepo] getAll() failed: $e');
      return [];
    }
  }

  void invalidate(String id) => _cache.remove(id);

  void clearCache() => _cache.clear();
}

class _CacheEntry {
  final Character character;
  final DateTime _createdAt;

  _CacheEntry(this.character) : _createdAt = DateTime.now();

  bool get isExpired =>
      DateTime.now().difference(_createdAt).inMinutes >= 30;
}
