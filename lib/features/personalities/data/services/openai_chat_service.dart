// FILE: lib/features/personalities/data/services/openai_chat_service.dart
// PURPOSE: Gemini multi-turn chat service with adaptive token pruning and classified error handling.
// SPRINT: 3

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:timeexplorer/core/config/app_config.dart';
import 'package:timeexplorer/core/services/gemini_service.dart';
import 'memory_scorer.dart';
import '../../domain/entities/character.dart';

class OpenAIChatService {
  static String get _modelName => AppConfig.geminiModel;
  static String get _apiKey => AppConfig.geminiApiKey;
  static const int _tokenThreshold = 3000;
  static const Duration _streamTimeout = Duration(seconds: 15);

  const OpenAIChatService();

  Future<String> send({
    required Character character,
    required String systemPrompt,
    required List<Map<String, String>> history,
  }) async {
    final cleanedKey = _apiKey;
    if (cleanedKey.isEmpty || !AppConfig.isAiEnabled) {
      // Return a user‑friendly message when the API key is not provided.
      return kAiUnavailableMessage;
    }

    final model = GenerativeModel(
      model: _modelName,
      apiKey: cleanedKey,
      systemInstruction: Content.system(systemPrompt),
    );

    final prunedHistory =
        await _pruneHistory(model, systemPrompt, history, character);
    final priorTurns = prunedHistory.length > 1
        ? prunedHistory.sublist(0, prunedHistory.length - 1)
        : const <Map<String, String>>[];
    final currentMessage = prunedHistory.last['content'] ?? '';

    final geminiHistory = _toGeminiHistory(priorTurns);

    try {
      return await _sendWithRetry(model, geminiHistory, currentMessage);
    } catch (e) {
      debugPrint('[GeminiChat] ❌ Final failure after retry: $e');
      rethrow;
    }
  }

  Stream<String> sendStream({
    required Character character,
    required String systemPrompt,
    required List<Map<String, String>> history,
  }) async* {
    final cleanedKey = _apiKey;
    if (cleanedKey.isEmpty || !AppConfig.isAiEnabled) {
      // Emit a single chunk with the unavailable message.
      yield kAiUnavailableMessage;
      return;
    }

    final model = GenerativeModel(
      model: _modelName,
      apiKey: cleanedKey,
      systemInstruction: Content.system(systemPrompt),
    );

    final prunedHistory =
        await _pruneHistory(model, systemPrompt, history, character);
    final priorTurns = prunedHistory.length > 1
        ? prunedHistory.sublist(0, prunedHistory.length - 1)
        : const <Map<String, String>>[];
    final currentMessage = prunedHistory.last['content'] ?? '';

    final geminiHistory = _toGeminiHistory(priorTurns);

    yield* _sendStreamWithRetry(model, geminiHistory, currentMessage);
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<List<Map<String, String>>> _pruneHistory(
    GenerativeModel model,
    String systemPrompt,
    List<Map<String, String>> history,
    Character character,
  ) async {
    final optimized = history
        .map((e) => {
              'role': e['role'] ?? 'user',
              'content': (e['content'] ?? '')
                  .trim()
                  .replaceAll(RegExp(r'\n{3,}'), '\n\n'),
            })
        .toList();

    var pruned = List<Map<String, String>>.from(optimized);

    while (pruned.length > 3) {
      final totalTokens =
          await _calculateTokens(model, systemPrompt, pruned);
      debugPrint(
          '[GeminiChat] 📊 ${pruned.length} msgs, $totalTokens tokens');
      if (totalTokens <= _tokenThreshold) break;

      final turns = MemoryScorer.toTurns(pruned);
      if (turns.length <= 2) break;

      final scores = <int, double>{};
      for (int i = 1; i < turns.length - 2; i++) {
        scores[i] = turns[i].score(character, turns.length);
      }
      if (scores.isEmpty) break;

      final lowest =
          scores.entries.reduce((a, b) => a.value < b.value ? a : b).key;
      debugPrint(
          '[GeminiChat] ⚖️ Pruning turn $lowest (score: ${scores[lowest]})');
      turns.removeAt(lowest);
      pruned = MemoryScorer.fromTurns(turns);
      pruned.add(optimized.last);
    }

    return pruned;
  }

  List<Content> _toGeminiHistory(List<Map<String, String>> turns) {
    return turns.map((e) {
      final role = e['role'] ?? 'user';
      final content = e['content'] ?? '';
      return role == 'user'
          ? Content.text(content)
          : Content('model', [TextPart(content)]);
    }).toList();
  }

  Future<String> _sendWithRetry(
    GenerativeModel model,
    List<Content> history,
    String currentMessage,
  ) async {
    int attempts = 0;
    while (attempts < 2) {
      attempts++;
      try {
        final chat = model.startChat(history: history.isEmpty ? null : history);
        final response = await chat
            .sendMessage(Content.text(currentMessage))
            .timeout(_streamTimeout);
        final text = _extractText(response);
        if (text.isNotEmpty) return text;
        throw const GeminiChatException(
            GeminiError.unknownError, 'Empty response from Gemini.');
      } on TimeoutException {
        if (attempts < 2) {
          debugPrint('[GeminiChat] ⏱ Non-stream timeout (attempt $attempts). Retrying in 2s...');
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }
        throw const GeminiChatException(
            GeminiError.timeoutError, 'Request timed out after 15 seconds.');
      } on InvalidApiKey {
        throw const GeminiChatException(
            GeminiError.unknownError, 'Invalid API Key.');
      } on ServerException catch (e) {
        final msg = e.message.toLowerCase();
        if (msg.contains('429') ||
            msg.contains('quota') ||
            msg.contains('rate')) {
          throw GeminiChatException(GeminiError.rateLimitError, e.message);
        }
        if (attempts >= 2) {
          throw GeminiChatException(GeminiError.unknownError, e.message);
        }
        await Future.delayed(
            Duration(milliseconds: 500 + DateTime.now().millisecond % 1000));
      } on GeminiChatException {
        rethrow;
      } catch (e) {
        if (attempts >= 2) {
          throw GeminiChatException(
              GeminiError.unknownError, e.toString());
        }
        await Future.delayed(
            Duration(milliseconds: 500 + DateTime.now().millisecond % 1000));
      }
    }
    throw const GeminiChatException(
        GeminiError.unknownError, 'Maximum retry attempts reached.');
  }

  Stream<String> _sendStreamWithRetry(
    GenerativeModel model,
    List<Content> history,
    String currentMessage,
  ) async* {
    int attempts = 0;
    bool anyChunkYielded = false;
    while (attempts < 2) {
      attempts++;
      try {
        final chat = model.startChat(history: history.isEmpty ? null : history);
        final stream = chat
            .sendMessageStream(Content.text(currentMessage))
            .timeout(_streamTimeout);

        await for (final chunk in stream) {
          final text = _extractTextStream(chunk);
          if (text.isNotEmpty) {
            anyChunkYielded = true;
            yield text;
          }
        }
        return;
      } on TimeoutException {
        // Only retry before first chunk — retrying mid-stream produces garbled text.
        if (!anyChunkYielded && attempts < 2) {
          debugPrint('[GeminiChat] ⏱ Stream timeout (attempt $attempts), no chunks yet. Retrying in 2s...');
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }
        throw const GeminiChatException(
            GeminiError.timeoutError, 'Stream timed out after 15 seconds.');
      } on InvalidApiKey {
        throw const GeminiChatException(
            GeminiError.unknownError, 'Invalid API Key.');
      } on ServerException catch (e) {
        final msg = e.message.toLowerCase();
        if (msg.contains('429') ||
            msg.contains('quota') ||
            msg.contains('rate')) {
          throw GeminiChatException(GeminiError.rateLimitError, e.message);
        }
        if (attempts >= 2) {
          throw GeminiChatException(GeminiError.unknownError, e.message);
        }
        debugPrint(
            '[GeminiChat] ⚠️ Stream error (attempt $attempts): $e. Retrying...');
        await Future.delayed(
            Duration(milliseconds: 500 + DateTime.now().millisecond % 1000));
      } on GeminiChatException {
        rethrow;
      } catch (e) {
        if (attempts >= 2) {
          throw GeminiChatException(
              GeminiError.unknownError, e.toString());
        }
        await Future.delayed(
            Duration(milliseconds: 500 + DateTime.now().millisecond % 1000));
      }
    }
    throw const GeminiChatException(
        GeminiError.unknownError, 'Maximum retry attempts reached.');
  }

  Future<int> _calculateTokens(
    GenerativeModel model,
    String system,
    List<Map<String, String>> history,
  ) async {
    try {
      final contents = <Content>[Content.system(system)];
      for (final h in history) {
        contents.add(h['role'] == 'user'
            ? Content.text(h['content'] ?? '')
            : Content('model', [TextPart(h['content'] ?? '')]));
      }
      final response =
          await model.countTokens(contents).timeout(const Duration(seconds: 5));
      return response.totalTokens;
    } catch (_) {
      return history.fold(
          0, (sum, e) => sum + (e['content']?.length ?? 0)) ~/ 4;
    }
  }

  String _extractText(GenerateContentResponse response) {
    if (response.text != null && response.text!.trim().isNotEmpty) {
      return response.text!.trim();
    }
    try {
      if (response.candidates.isNotEmpty) {
        final text = response.candidates.first.content.parts
            .whereType<TextPart>()
            .map((p) => p.text)
            .join('')
            .trim();
        if (text.isNotEmpty) return text;
      }
    } catch (_) {}
    return '';
  }

  String _extractTextStream(GenerateContentResponse response) {
    if (response.text != null && response.text!.isNotEmpty) {
      return response.text!;
    }
    try {
      if (response.candidates.isNotEmpty) {
        final text = response.candidates.first.content.parts
            .whereType<TextPart>()
            .map((p) => p.text)
            .join('');
        if (text.isNotEmpty) return text;
      }
    } catch (_) {}
    return '';
  }
}
