// FILE: lib/features/personalities/data/services/conversation_manager.dart
// PURPOSE: In-memory conversation state manager with sliding window and session summary injection.
// SPRINT: 2

import '../models/message_model.dart';

class ConversationManager {
  static const int _slidingWindowSize = 10;

  final List<MessageModel> _messages = [];
  String? _sessionSummary;
  String _systemPrompt = '';

  void setSystemPrompt(String prompt) => _systemPrompt = prompt;

  void setSessionSummary(String? summary) => _sessionSummary = summary;

  String get systemPrompt => _systemPrompt;

  String? get sessionSummary => _sessionSummary;

  bool get hasMessages => _messages.isNotEmpty;

  void addMessage(MessageModel message) => _messages.add(message);

  void removeLastMessage() {
    if (_messages.isNotEmpty) _messages.removeLast();
  }

  List<MessageModel> getHistory() => List.unmodifiable(_messages);

  void loadMessages(List<MessageModel> messages) {
    _messages
      ..clear()
      ..addAll(messages);
  }

  void clearSession() {
    _messages.clear();
    _sessionSummary = null;
  }

  // Returns a flat [{role, content}] list for the Gemini chat service.
  // Structure: [summary_pair?] + [last N messages].
  // The last entry is always the most recent user message (current input).
  List<Map<String, String>> getApiPayload() {
    final payload = <Map<String, String>>[];

    if (_sessionSummary != null && _sessionSummary!.isNotEmpty) {
      payload.add({
        'role': 'user',
        'content': '[CONTEXT FROM PREVIOUS SESSION]: $_sessionSummary',
      });
      payload.add({
        'role': 'model',
        'content': 'I recall our previous conversation. Let us continue.',
      });
    }

    final window = _messages.length > _slidingWindowSize
        ? _messages.sublist(_messages.length - _slidingWindowSize)
        : List<MessageModel>.from(_messages);

    for (final msg in window) {
      payload.add({
        'role': msg.role == MessageRole.user ? 'user' : 'model',
        'content': msg.content,
      });
    }

    return payload;
  }
}
