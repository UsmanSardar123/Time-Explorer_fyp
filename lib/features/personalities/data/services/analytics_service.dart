// FILE: lib/features/personalities/data/services/analytics_service.dart
// PURPOSE: Firebase Analytics event logging for the chat module — 6 events only.
// SPRINT: 5

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final _analytics = FirebaseAnalytics.instance;

  static Future<void> logChatSessionStarted({
    required String characterId,
    required String userId,
  }) =>
      _safeLog('chat_session_started',
          {'character_id': characterId, 'user_id': userId});

  static Future<void> logMessageSent({
    required String characterId,
    required int messageLength,
  }) =>
      _safeLog('message_sent',
          {'character_id': characterId, 'message_length': messageLength});

  static Future<void> logSuggestionChipTapped({
    required String characterId,
    required String chipText,
  }) =>
      _safeLog('suggestion_chip_tapped',
          {'character_id': characterId, 'chip_text': chipText});

  static Future<void> logContextCardExpanded({
    required String characterId,
    required String keyword,
  }) =>
      _safeLog('context_card_expanded',
          {'character_id': characterId, 'keyword': keyword});

  static Future<void> logCharacterBreakDetected({
    required String characterId,
    required String responseSnippet,
  }) =>
      _safeLog('character_break_detected', {
        'character_id': characterId,
        'response_snippet': responseSnippet.length > 50
            ? responseSnippet.substring(0, 50)
            : responseSnippet,
      });

  static Future<void> logRateLimitHit({
    required String userId,
    required String characterId,
  }) =>
      _safeLog('rate_limit_hit',
          {'user_id': userId, 'character_id': characterId});

  static Future<void> _safeLog(
      String name, Map<String, Object> parameters) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      debugPrint('[Analytics] $name failed (non-fatal): $e');
    }
  }
}
