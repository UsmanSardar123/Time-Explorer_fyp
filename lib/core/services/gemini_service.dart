import 'package:flutter/foundation.dart';
import 'package:timeexplorer/core/services/api_service.dart';

enum GeminiError { networkError, rateLimitError, contentFilterError, unknownError, timeoutError }

/// Friendly message shown in UI when AI is unavailable.
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
  final ApiService _api;

  GeminiService({ApiService? api}) : _api = api ?? ApiService();

  Future<String> generateResponse(String prompt) async {
    if (prompt.trim().isEmpty) return kAiUnavailableMessage;
    try {
      final data = await _api.post('/ai/ask', {'prompt': prompt.trim()});
      final text = data['response'] as String?;
      if (text != null && text.trim().isNotEmpty) return text.trim();
      return kAiUnavailableMessage;
    } on ApiException catch (e) {
      debugPrint('[GeminiService] ApiException ${e.statusCode}: ${e.message}');
      if (e.isUnauthorized) {
        throw GeminiChatException(GeminiError.networkError, e.message);
      }
      return kAiUnavailableMessage;
    } on ApiNetworkException catch (e) {
      debugPrint('[GeminiService] Network error: $e');
      throw GeminiChatException(GeminiError.networkError, e.message);
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
