import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:timeexplorer/core/services/api_service.dart';

class LocalGuideService {
  const LocalGuideService();

  // Keep Stream<String> — LocalGuideCubit uses `await for` over the stream.
  // The backend returns a single batch response, yielded as one chunk.
  Stream<String> sendStream({
    required String systemPrompt,
    required List<Map<String, String>> history,
  }) async* {
    final api = ApiService();
    try {
      final currentMessage = history.isNotEmpty ? (history.last['content'] ?? '') : '';
      final priorTurns = history.length > 1
          ? history.sublist(0, history.length - 1)
          : <Map<String, String>>[];

      final buffer = StringBuffer();
      buffer.writeln('ROLE:\n$systemPrompt\n');
      if (priorTurns.isNotEmpty) {
        buffer.writeln('CONVERSATION HISTORY:');
        for (final h in priorTurns) {
          final role = h['role'] == 'user' ? 'Visitor' : 'Guide';
          buffer.writeln('$role: ${h['content']}');
        }
        buffer.writeln();
      }
      buffer.writeln('Visitor: $currentMessage');
      buffer.writeln('\nRespond as the local guide:');

      final data = await api.post('/ai/ask', {'prompt': buffer.toString()});
      final text = (data['response'] as String? ?? '').trim();
      if (text.isNotEmpty) yield text;
    } on ApiException catch (e) {
      debugPrint('[LocalGuideService] API error: $e');
      throw Exception(e.isUnauthorized ? 'Please sign in again.' : 'Something went wrong. Please try again.');
    } on ApiNetworkException {
      throw Exception('Response timed out. Please try again.');
    } catch (e) {
      debugPrint('[LocalGuideService] error: $e');
      rethrow;
    }
  }
}
