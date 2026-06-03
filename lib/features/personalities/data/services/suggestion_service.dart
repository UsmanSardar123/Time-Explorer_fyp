// FILE: lib/features/personalities/data/services/suggestion_service.dart
// PURPOSE: Generates 3 follow-up question chips via a lightweight Gemini call after each response.
// SPRINT: 4

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:timeexplorer/core/config/app_config.dart';
import '../models/message_model.dart';
import '../../domain/entities/character.dart';

class SuggestionService {
  static const _modelName = AppConfig.geminiModel;

  const SuggestionService();

  Future<List<String>> getSuggestions({
    required Character character,
    required List<MessageModel> recentMessages,
  }) async {
    final key = AppConfig.geminiApiKey;
    if (key.isEmpty) return [];

    try {
      final model = GenerativeModel(
        model: _modelName,
        apiKey: key,
        generationConfig: GenerationConfig(maxOutputTokens: 150),
      );

      final transcript = recentMessages
          .reversed
          .take(6)
          .toList()
          .reversed
          .map((m) =>
              '${m.role == MessageRole.user ? "User" : character.name}: ${m.content}')
          .join('\n');

      final prompt =
          'Given this conversation with ${character.name}, write exactly 3 short '
          'follow-up questions a curious student might ask. Each question max 8 words. '
          'Return as JSON array of strings only. No other text.\n\n$transcript';

      final response = await model
          .generateContent([Content.text(prompt)]).timeout(
              const Duration(seconds: 10));

      final raw = response.text?.trim() ?? '';
      if (raw.isEmpty) return [];

      final cleaned = raw
          .replaceAll(RegExp(r'```json\s*'), '')
          .replaceAll(RegExp(r'```\s*'), '')
          .trim();

      final decoded = jsonDecode(cleaned);
      if (decoded is List) {
        return decoded
            .whereType<String>()
            .where((s) => s.trim().isNotEmpty)
            .take(3)
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('[SuggestionService] failed (non-fatal): $e');
      return [];
    }
  }
}
