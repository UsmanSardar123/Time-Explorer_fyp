import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timeexplorer/core/config/app_config.dart';
import 'memory_scorer.dart';
import '../../domain/entities/character.dart';

/// Gemini-backed chat service for personality conversations.
/// Uses multi-turn chat with a system prompt to maintain character persona.
class OpenAIChatService {
  static const _modelName = 'gemini-flash-latest';
  static String get _apiKey => AppConfig.geminiApiKey;
  static const int _tokenThreshold = 3000;

  const OpenAIChatService();

  Future<String> send({
    required Character character,
    required String systemPrompt,
    required List<Map<String, String>> history,
  }) async {
    final cleanedKey = _apiKey;

    if (cleanedKey.isEmpty) {
      debugPrint('[GeminiChat] ❌ API KEY MISSING');
      throw const _GeminiException('Error: GEMINI_API_KEY is missing. Run with --dart-define or use .env file');
    }

    // 1. Aggressive Content Trimming for history
    final optimizedHistory = history.map((e) => {
      'role': e['role'] ?? 'user',
      'content': (e['content'] ?? '').trim().replaceAll(RegExp(r'\n{3,}'), '\n\n'),
    }).toList();

    // 2. Adaptive Token Pruning
    List<Map<String, String>> prunedHistory = List.from(optimizedHistory);
    
    // We create the model early just to count tokens
    final model = GenerativeModel(
      model: _modelName,
      apiKey: cleanedKey,
      systemInstruction: Content.system(systemPrompt),
    );

    // Iteratively prune low-value turns until under threshold
    while (prunedHistory.length > 3) {
      final totalTokens = await _calculateTokens(model, systemPrompt, prunedHistory);
      debugPrint('[GeminiChat] 📊 Current Context: ${prunedHistory.length} msgs, $totalTokens tokens');
      
      if (totalTokens <= _tokenThreshold) break;

      // Hit threshold - Prune weighted memory
      final turns = MemoryScorer.toTurns(prunedHistory);
      if (turns.length <= 2) break; // Keep at least last 2 turns

      // Score everything except the anchor (0) and last 2 turns
      // We keep indices 0 and turns.length-1, turns.length-2
      final turnScores = <int, double>{};
      for (int i = 1; i < turns.length - 2; i++) {
        turnScores[i] = turns[i].score(character, turns.length);
      }

      if (turnScores.isEmpty) break;

      // Find turn with lowest score
      final lowestIndex = turnScores.entries
          .reduce((a, b) => a.value < b.value ? a : b)
          .key;

      debugPrint('[GeminiChat] ⚖️ Pruning turn $lowestIndex (score: ${turnScores[lowestIndex]})');
      turns.removeAt(lowestIndex);
      prunedHistory = MemoryScorer.fromTurns(turns);
      // Ensure current user message (last) is still there
      prunedHistory.add(optimizedHistory.last);
    }

    final priorTurns = prunedHistory.length > 1
        ? prunedHistory.sublist(0, prunedHistory.length - 1)
        : const <Map<String, String>>[];

    final geminiHistory = <Content>[];
    for (final entry in priorTurns) {
      final role = entry['role'] ?? 'user';
      final content = entry['content'] ?? '';
      if (role == 'user') {
        geminiHistory.add(Content.text(content));
      } else {
        geminiHistory.add(Content('model', [TextPart(content)]));
      }
    }

    final currentMessage = prunedHistory.last['content'] ?? '';

    try {
      return await _sendWithRetry(model, geminiHistory, currentMessage);
    } catch (e) {
      debugPrint('[GeminiChat] ❌ Final failure after retry: $e');
      rethrow;
    }
  }

  Future<String> _sendWithRetry(GenerativeModel model, List<Content> geminiHistory, String currentMessage) async {
    int attempts = 0;
    const maxAttempts = 2; // 1 original + 1 retry

    while (attempts < maxAttempts) {
      attempts++;
      try {
        final chat = model.startChat(
          history: geminiHistory.isEmpty ? null : geminiHistory,
        );

        // Add a 15-second timeout for the request
        final response = await chat.sendMessage(Content.text(currentMessage))
            .timeout(const Duration(seconds: 15));
            
        final text = _extractText(response);
        if (text.isNotEmpty) return text;
        
        throw const _GeminiException('Error: Received an empty response from history service.');
      } catch (e) {
        final isLastAttempt = attempts >= maxAttempts;
        final isPermanent = e is InvalidApiKey || e is UnsupportedUserLocation;

        if (isLastAttempt || isPermanent) {
          if (e is _GeminiException) rethrow;
          if (e is InvalidApiKey) throw const _GeminiException('Error: Invalid API Key');
          if (e is ServerException) throw const _GeminiException('Error: Gemini Server is overloaded');
          throw _GeminiException('Error: ${e.toString()}');
        }

        // Transient error - retry with randomized backoff
        final backoffMs = 500 + (DateTime.now().millisecond % 1000);
        debugPrint('[GeminiChat] ⚠️ Transient error (attempt $attempts): $e. Retrying in ${backoffMs}ms...');
        await Future.delayed(Duration(milliseconds: backoffMs));
      }
    }
    throw const _GeminiException('Error: Maximum retry attempts reached');
  }

  Future<int> _calculateTokens(GenerativeModel model, String system, List<Map<String, String>> history) async {
    try {
      final contents = <Content>[Content.system(system)];
      for (final h in history) {
        contents.add(h['role'] == 'user' 
            ? Content.text(h['content'] ?? '') 
            : Content('model', [TextPart(h['content'] ?? '')]));
      }
      final response = await model.countTokens(contents).timeout(const Duration(seconds: 5));
      return response.totalTokens;
    } catch (e) {
      debugPrint('[GeminiChat] ⚠️ Token count failed: $e. Falling back to estimate.');
      // Simple heuristic fallback if counting fails (chars / 4)
      return history.fold(0, (sum, e) => sum + (e['content']?.length ?? 0)) ~/ 4;
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
}

class _GeminiException implements Exception {
  final String message;
  const _GeminiException(this.message);

  @override
  String toString() => message;
}
