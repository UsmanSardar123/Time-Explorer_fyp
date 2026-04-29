// FILE: lib/features/places/data/services/place_insights_service.dart
// PURPOSE: Fetches AI-generated insights for a place, using Firestore as a 7-day cache.
// SPRINT: 3 — TASK 3.5

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:timeexplorer/core/config/app_config.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';

class PlaceInsightsService {
  static const _collection = 'aiInsightsCache';
  static const _modelName = 'gemini-1.5-flash-latest';

  final FirebaseFirestore _firestore;

  PlaceInsightsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<String>> getInsights(Place place) async {
    final cacheKey = place.aiInsightsCacheKey ?? place.id;
    try {
      final cached = await _loadFromCache(cacheKey);
      if (cached != null) return cached;
      return await _fetchFromGemini(place, cacheKey);
    } catch (e) {
      debugPrint('[PlaceInsightsService] Failed for ${place.id}: $e');
      return [];
    }
  }

  Future<List<String>?> _loadFromCache(String cacheKey) async {
    try {
      final doc = await _firestore.collection(_collection).doc(cacheKey).get();
      if (!doc.exists) return null;
      final data = doc.data()!;
      final expiresAt = (data['expiresAt'] as Timestamp?)?.toDate();
      if (expiresAt == null || DateTime.now().isAfter(expiresAt)) return null;
      final raw = data['insights'] as List<dynamic>?;
      return raw?.map((e) => e.toString()).toList();
    } catch (_) {
      return null;
    }
  }

  Future<List<String>> _fetchFromGemini(Place place, String cacheKey) async {
    final apiKey = AppConfig.geminiApiKey;
    if (apiKey.isEmpty) return [];

    final model = GenerativeModel(model: _modelName, apiKey: apiKey);
    final prompt =
        'Give me exactly 3 surprising, lesser-known facts about ${place.name} '
        'in ${place.country ?? place.location}. Each fact must be historically accurate, '
        'max 25 words, and begin with a number (1., 2., 3.). '
        'Return only the 3 facts, no intro text.';

    final response = await model
        .generateContent([Content.text(prompt)]).timeout(
            const Duration(seconds: 15));
    final text = response.text ?? '';
    final facts = _parseFacts(text);
    if (facts.isNotEmpty) await _writeToCache(cacheKey, place.id, facts);
    return facts;
  }

  List<String> _parseFacts(String text) {
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final facts = <String>[];
    for (final line in lines) {
      final cleaned = line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();
      if (cleaned.isNotEmpty) facts.add(cleaned);
      if (facts.length == 3) break;
    }
    return facts;
  }

  Future<void> _writeToCache(
      String cacheKey, String placeId, List<String> insights) async {
    final now = DateTime.now();
    await _firestore.collection(_collection).doc(cacheKey).set({
      'placeId': placeId,
      'insights': insights,
      'generatedAt': Timestamp.fromDate(now),
      'expiresAt': Timestamp.fromDate(now.add(const Duration(days: 7))),
    });
  }
}
