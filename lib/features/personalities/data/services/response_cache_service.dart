// FILE: lib/features/personalities/data/services/response_cache_service.dart
// PURPOSE: MD5-keyed Firestore response cache with 7-day TTL and hit counting.
// SPRINT: 5

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class ResponseCacheService {
  static const Duration _ttl = Duration(days: 7);
  static const String _collection = 'responseCache';

  final FirebaseFirestore _firestore;

  ResponseCacheService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  String _cacheKey(String characterId, String message) {
    final normalized = message
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
    return md5.convert(utf8.encode('$characterId:$normalized')).toString();
  }

  Future<String?> checkCache(String characterId, String message) async {
    final key = _cacheKey(characterId, message);
    try {
      final doc =
          await _firestore.collection(_collection).doc(key).get();
      if (!doc.exists || doc.data() == null) return null;

      final data = doc.data()!;
      final createdAt = data['createdAt'] as int? ?? 0;
      final age = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(createdAt));

      if (age > _ttl) {
        doc.reference.delete().ignore();
        return null;
      }

      final response = data['response'] as String?;
      if (response == null || response.isEmpty) return null;

      doc.reference
          .update({'hitCount': FieldValue.increment(1)}).ignore();
      debugPrint('[ResponseCache] Cache hit for $characterId');
      return response;
    } catch (e) {
      debugPrint('[ResponseCache] checkCache failed (non-fatal): $e');
      return null;
    }
  }

  void saveToCache(String characterId, String message, String response) {
    final key = _cacheKey(characterId, message);
    _firestore.collection(_collection).doc(key).set({
      'response': response,
      'hitCount': 1,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    }).catchError((e) {
      debugPrint('[ResponseCache] saveToCache failed (non-fatal): $e');
    });
  }
}
