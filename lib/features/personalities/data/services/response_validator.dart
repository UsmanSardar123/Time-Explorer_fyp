// FILE: lib/features/personalities/data/services/response_validator.dart
// PURPOSE: Synchronous local validator that flags anachronistic responses and logs breaks to Firestore.
// SPRINT: 3

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'analytics_service.dart';

class ValidationResult {
  final String text;
  final bool brokenCharacter;

  const ValidationResult({required this.text, required this.brokenCharacter});
}

class ResponseValidator {
  static const List<String> _anachronisms = [
    'internet',
    'smartphone',
    'computer',
    'artificial intelligence',
    ' ai ',
    'robot',
    '21st century',
    '20th century',
  ];

  // Synchronous. Firestore logging is fire-and-forget.
  static ValidationResult validate(String response, String characterId) {
    final lower = response.toLowerCase();
    final isBroken = _anachronisms.any((word) => lower.contains(word));

    if (!isBroken) {
      return ValidationResult(text: response, brokenCharacter: false);
    }

    unawaited(_logBreak(characterId, response));
    unawaited(AnalyticsService.logCharacterBreakDetected(
      characterId: characterId,
      responseSnippet: response,
    ));

    return ValidationResult(
      text: '$response\n\n[Note: This character\'s response may contain an anachronism.]',
      brokenCharacter: true,
    );
  }

  static Future<void> _logBreak(String characterId, String response) async {
    try {
      await FirebaseFirestore.instance
          .collection('logs')
          .doc('characterBreaks')
          .collection('entries')
          .add({
        'characterId': characterId,
        'responseSnippet':
            response.length > 200 ? response.substring(0, 200) : response,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (_) {
      // Non-fatal — logging failure must never surface to the user.
    }
  }
}
