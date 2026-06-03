// FILE: lib/features/places/data/services/local_guide_service.dart
// PURPOSE: Lightweight Gemini streaming service for the Talk to Local guide chat.
// SPRINT: local-guide

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:timeexplorer/core/config/app_config.dart';

class LocalGuideService {
  static String get _model => AppConfig.geminiModel;
  static const Duration _timeout = Duration(seconds: 15);

  const LocalGuideService();

  Stream<String> sendStream({
    required String systemPrompt,
    required List<Map<String, String>> history,
  }) async* {
    if (AppConfig.geminiApiKey.isEmpty) {
      throw Exception('Gemini API key is missing.');
    }

    final model = GenerativeModel(
      model: _model,
      apiKey: AppConfig.geminiApiKey,
      systemInstruction: Content.system(systemPrompt),
    );

    final priorTurns = history.length > 1
        ? history.sublist(0, history.length - 1)
        : const <Map<String, String>>[];
    final currentMessage = history.last['content'] ?? '';

    final geminiHistory = priorTurns.map((h) {
      return h['role'] == 'user'
          ? Content.text(h['content'] ?? '')
          : Content('model', [TextPart(h['content'] ?? '')]);
    }).toList();

    try {
      final chat =
          model.startChat(history: geminiHistory.isEmpty ? null : geminiHistory);
      final stream = chat
          .sendMessageStream(Content.text(currentMessage))
          .timeout(_timeout);

      await for (final response in stream) {
        final text = response.text;
        if (text != null && text.isNotEmpty) yield text;
      }
    } on TimeoutException {
      throw Exception('Response timed out. Please try again.');
    } on InvalidApiKey {
      throw Exception('Invalid Gemini API key.');
    } catch (e) {
      debugPrint('[LocalGuideService] error: $e');
      rethrow;
    }
  }
}
