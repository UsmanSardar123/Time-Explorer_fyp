// FILE: lib/core/services/gemini_service.dart
// PURPOSE: Core Gemini service with error classification types and simple one-shot generation.
// SPRINT: 3

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:timeexplorer/core/config/app_config.dart';

enum GeminiError { networkError, rateLimitError, contentFilterError, unknownError, timeoutError }

/// Friendly message shown in UI when AI is unavailable (no key configured).
const kAiUnavailableMessage =
    'AI features are currently unavailable. Please check back later.';

class GeminiChatException implements Exception {
  final GeminiError error;
  final String message;

  const GeminiChatException(this.error, this.message);

  @override
  String toString() => 'GeminiChatException($error): $message';
}

class GeminiService {
  static const _modelName = AppConfig.geminiModel;

  static String get apiKey => AppConfig.geminiApiKey;

  GenerativeModel _buildModel() {
    final cleanedKey = apiKey.trim();
    if (cleanedKey.isEmpty) {
      debugPrint('[GeminiService] ❌ API KEY MISSING');
      throw Exception(
          'GEMINI_API_KEY is missing. Run with --dart-define=GEMINI_API_KEY=<key>');
    }
    debugPrint('[GeminiService] 🔑 Key length: ${cleanedKey.length}, model: $_modelName');
    return GenerativeModel(
      model: _modelName,
      apiKey: cleanedKey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      ],
    );
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

  Future<String> generateResponse(String prompt) async {
    if (!AppConfig.isAiEnabled) return kAiUnavailableMessage;
    try {
      final model = _buildModel();
      final response = await model.generateContent([Content.text(prompt)]);
      final text = _extractText(response);
      if (text.isNotEmpty) return text;
      return kAiUnavailableMessage;
    } on InvalidApiKey catch (_) {
      return kAiUnavailableMessage;
    } on ServerException catch (e) {
      debugPrint('[GeminiService] ServerException: $e');
      return kAiUnavailableMessage;
    } on SocketException catch (_) {
      return kAiUnavailableMessage;
    } catch (e) {
      debugPrint('[GeminiService] Unexpected error: $e');
      return kAiUnavailableMessage;
    }
  }

  Future<void> testConnection() async {
    final result = await generateResponse('Hello');
    debugPrint('[GeminiService] Test result: $result');
  }
}
