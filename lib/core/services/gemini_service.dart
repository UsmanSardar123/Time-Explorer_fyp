// FILE: lib/core/services/gemini_service.dart
// PURPOSE: Core Gemini service with error classification types and simple one-shot generation.
// SPRINT: 3

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:timeexplorer/core/config/app_config.dart';

enum GeminiError { networkError, rateLimitError, contentFilterError, unknownError, timeoutError }

class GeminiChatException implements Exception {
  final GeminiError error;
  final String message;

  const GeminiChatException(this.error, this.message);

  @override
  String toString() => 'GeminiChatException($error): $message';
}

class GeminiService {
  static const _modelName = 'gemini-flash-latest';

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
    try {
      final model = _buildModel();
      final response = await model.generateContent([Content.text(prompt)]);
      final text = _extractText(response);
      if (text.isNotEmpty) return text;
      return 'Error: Empty response from Gemini';
    } on InvalidApiKey catch (_) {
      return 'Error: Invalid API Key — check your --dart-define value';
    } on ServerException catch (e) {
      debugPrint('[GeminiService] ServerException: $e');
      return 'Error: Server Issue — Gemini is unavailable';
    } on SocketException catch (_) {
      return 'Error: Network Issue — check your internet connection';
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('GEMINI_API_KEY is missing')) {
        return 'Error: GEMINI_API_KEY is missing. Run with --dart-define';
      }
      debugPrint('[GeminiService] Unexpected error: $e');
      return 'Error: $msg';
    }
  }

  Future<void> testConnection() async {
    final result = await generateResponse('Hello');
    debugPrint('[GeminiService] Test result: $result');
  }
}
