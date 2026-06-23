// FILE: lib/features/personalities/data/repositories/character_firestore_repository.dart
// PURPOSE: Fetches Character documents from backend API with 30-minute in-memory cache.

import 'package:flutter/foundation.dart';
import 'package:timeexplorer/core/services/api_service.dart';
import '../../../admin/data/models/character_model.dart';
import '../../domain/entities/character.dart';

class CharacterFirestoreRepository {
  final ApiService _api;
  final Map<String, _CacheEntry> _cache = {};

  CharacterFirestoreRepository({ApiService? api}) : _api = api ?? ApiService();

  Future<Character?> getById(String id) async {
    final cached = _cache[id];
    if (cached != null && !cached.isExpired) return cached.character;

    try {
      final data = await _api.get('/characters/$id') as Map<String, dynamic>;
      final character = CharacterModel.fromMap(data, data['id'] as String? ?? id);
      _cache[id] = _CacheEntry(character);
      return character;
    } on ApiException catch (e) {
      if (e.statusCode == 404) return cached?.character;
      debugPrint('[CharacterRepo] getById($id) API error: $e');
      return cached?.character;
    } catch (e) {
      debugPrint('[CharacterRepo] getById($id) failed: $e');
      return cached?.character;
    }
  }

  Future<List<Character>> getAll() async {
    try {
      final raw = await _api.get('/characters') as List;
      final characters = raw
          .cast<Map<String, dynamic>>()
          .map((d) => CharacterModel.fromMap(d, d['id'] as String? ?? ''))
          .toList();
      for (final c in characters) {
        _cache[c.id] = _CacheEntry(c);
      }
      return characters;
    } catch (e) {
      debugPrint('[CharacterRepo] getAll() failed: $e');
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

  bool get isExpired => DateTime.now().difference(_createdAt).inMinutes >= 30;
}
