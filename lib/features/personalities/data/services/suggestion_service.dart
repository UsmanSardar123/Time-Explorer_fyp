import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:timeexplorer/core/services/api_service.dart';
import '../models/message_model.dart';
import '../../domain/entities/character.dart';

class SuggestionService {
  final ApiService _api;

  SuggestionService({ApiService? api}) : _api = api ?? ApiService();

  Future<List<String>> getSuggestions({
    required Character character,
    required List<MessageModel> recentMessages,
  }) async {
    try {
      final transcript = recentMessages
          .reversed
          .take(6)
          .toList()
          .reversed
          .map((m) => '${m.role == MessageRole.user ? "User" : character.name}: ${m.content}')
          .join('\n');

      final prompt =
          'Given this conversation with ${character.name}, write exactly 3 short '
          'follow-up questions a curious student might ask. Each question max 8 words. '
          'Return as JSON array of strings only. No other text.\n\n$transcript';

      final data = await _api.post('/ai/ask', {'prompt': prompt});
      final raw = (data['response'] as String? ?? '').trim();
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
