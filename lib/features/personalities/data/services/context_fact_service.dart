// FILE: lib/features/personalities/data/services/context_fact_service.dart
// PURPOSE: Fetches and caches keyword→fact maps from Firestore for historical context cards.
// SPRINT: 4

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ContextFactService {
  final FirebaseFirestore _firestore;
  final Map<String, Map<String, String>> _cache = {};

  ContextFactService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<String, String>> getContextFacts(String characterId) async {
    if (_cache.containsKey(characterId)) return _cache[characterId]!;

    try {
      final doc = await _firestore
          .collection('characters')
          .doc(characterId)
          .get();
      final raw = doc.data()?['contextFacts'] as Map<String, dynamic>?;
      final facts = raw?.map((k, v) => MapEntry(k, v.toString())) ?? {};
      _cache[characterId] = facts;
      return facts;
    } catch (e) {
      debugPrint('[ContextFactService] fetch failed: $e');
      return {};
    }
  }

  String? matchFact(Map<String, String> facts, String responseText) {
    if (facts.isEmpty || responseText.isEmpty) return null;
    final lower = responseText.toLowerCase();
    for (final entry in facts.entries) {
      if (lower.contains(entry.key.toLowerCase())) return entry.value;
    }
    return null;
  }
}
