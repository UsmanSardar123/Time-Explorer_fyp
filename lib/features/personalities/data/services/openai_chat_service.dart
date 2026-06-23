// FILE: lib/features/personalities/data/services/openai_chat_service.dart
// PURPOSE: Multi-turn chat service routing through Node.js backend (/api/ai/ask).
//          Preserves adaptive history pruning (character-count based) and retry logic.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:timeexplorer/core/services/api_service.dart';
import 'package:timeexplorer/core/services/gemini_service.dart';
import 'memory_scorer.dart';
import '../../domain/entities/character.dart';

class OpenAIChatService {
  // Token budget before history pruning kicks in (~3 000 tokens ≈ 12 000 chars)
  static const int _tokenThreshold = 3000;

  const OpenAIChatService();

  Future<String> send({
    required Character character,
    required String systemPrompt,
    required List<Map<String, String>> history,
  }) async {
    try {
      final pruned = await _pruneHistory(systemPrompt, history, character);
      final prompt = _buildPrompt(character, systemPrompt, pruned);
      final api = ApiService();
      final data = await api.post('/ai/ask', {'prompt': prompt});
      final text = (data['response'] as String? ?? '').trim();
      if (text.isNotEmpty) return text;
      throw GeminiChatException(GeminiError.unknownError, 'Empty response from AI.');
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        throw GeminiChatException(GeminiError.networkError, 'Session expired. Please sign in again.');
      }
      throw GeminiChatException(GeminiError.unknownError, e.message);
    } on ApiNetworkException catch (e) {
      throw GeminiChatException(GeminiError.networkError, e.message);
    } on GeminiChatException {
      rethrow;
    } catch (e) {
      debugPrint('[OpenAIChatService] ❌ send failed: $e');
      throw GeminiChatException(GeminiError.unknownError, e.toString());
    }
  }

  // Keep Stream<String> — ChatCubit uses `await for` over this stream.
  Stream<String> sendStream({
    required Character character,
    required String systemPrompt,
    required List<Map<String, String>> history,
  }) async* {
    try {
      final pruned = await _pruneHistory(systemPrompt, history, character);
      final prompt = _buildPrompt(character, systemPrompt, pruned);
      final api = ApiService();

      // Retry up to 2 times before giving up
      for (int attempt = 1; attempt <= 2; attempt++) {
        try {
          final data = await api.post('/ai/ask', {'prompt': prompt});
          final text = (data['response'] as String? ?? '').trim();
          if (text.isNotEmpty) {
            yield text;
            return;
          }
          throw GeminiChatException(GeminiError.unknownError, 'Empty response from AI.');
        } on ApiException catch (e) {
          if (e.isUnauthorized) {
            throw GeminiChatException(GeminiError.networkError, 'Session expired.');
          }
          if (e.statusCode == 504) {
            throw const GeminiChatException(GeminiError.timeoutError, 'Request timed out after 15 seconds.');
          }
          if (attempt >= 2) throw GeminiChatException(GeminiError.unknownError, e.message);
          await Future.delayed(Duration(milliseconds: 500 + DateTime.now().millisecond % 1000));
        } on ApiNetworkException catch (e) {
          if (attempt >= 2) throw GeminiChatException(GeminiError.networkError, e.message);
          await Future.delayed(const Duration(seconds: 2));
        } on GeminiChatException {
          rethrow;
        } catch (e) {
          if (attempt >= 2) throw GeminiChatException(GeminiError.unknownError, e.toString());
          await Future.delayed(Duration(milliseconds: 500 + DateTime.now().millisecond % 1000));
        }
      }
    } on GeminiChatException {
      rethrow;
    } catch (e) {
      debugPrint('[OpenAIChatService] ❌ sendStream failed: $e');
      throw GeminiChatException(GeminiError.unknownError, e.toString());
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  String _buildPrompt(
    Character character,
    String systemPrompt,
    List<Map<String, String>> history,
  ) {
    final buffer = StringBuffer();
    buffer.writeln('PERSONA:\n$systemPrompt\n');

    final priorTurns = history.length > 1
        ? history.sublist(0, history.length - 1)
        : <Map<String, String>>[];

    if (priorTurns.isNotEmpty) {
      buffer.writeln('CONVERSATION HISTORY:');
      for (final h in priorTurns) {
        final role = h['role'] == 'user' ? 'Student' : character.name;
        buffer.writeln('$role: ${h['content']}');
      }
      buffer.writeln();
    }

    final lastMessage = history.isNotEmpty ? (history.last['content'] ?? '') : '';
    buffer.writeln('Student: $lastMessage');
    buffer.writeln('\nRespond as ${character.name}. Be in character:');
    return buffer.toString();
  }

  Future<List<Map<String, String>>> _pruneHistory(
    String systemPrompt,
    List<Map<String, String>> history,
    Character character,
  ) async {
    final optimized = history
        .map((e) => {
              'role': e['role'] ?? 'user',
              'content': (e['content'] ?? '').trim().replaceAll(RegExp(r'\n{3,}'), '\n\n'),
            })
        .toList();

    var pruned = List<Map<String, String>>.from(optimized);

    while (pruned.length > 3) {
      final totalTokens = _estimateTokens(systemPrompt, pruned);
      debugPrint('[OpenAIChatService] 📊 ${pruned.length} msgs, ~$totalTokens tokens');
      if (totalTokens <= _tokenThreshold) break;

      final turns = MemoryScorer.toTurns(pruned);
      if (turns.length <= 2) break;

      final scores = <int, double>{};
      for (int i = 1; i < turns.length - 2; i++) {
        scores[i] = turns[i].score(character, turns.length);
      }
      if (scores.isEmpty) break;

      final lowest = scores.entries.reduce((a, b) => a.value < b.value ? a : b).key;
      debugPrint('[OpenAIChatService] ⚖️ Pruning turn $lowest (score: ${scores[lowest]})');
      turns.removeAt(lowest);
      pruned = MemoryScorer.fromTurns(turns);
      pruned.add(optimized.last);
    }

    return pruned;
  }

  // Approximate token count: ~4 characters per token (replaces SDK countTokens)
  int _estimateTokens(String systemPrompt, List<Map<String, String>> history) {
    final systemTokens = systemPrompt.length ~/ 4;
    final historyTokens = history.fold(
        0, (sum, e) => sum + (e['content']?.length ?? 0)) ~/ 4;
    return systemTokens + historyTokens;
  }
}
