// FILE: lib/features/personalities/presentation/cubit/chat_state.dart
// PURPOSE: Chat session state carrying messages, typing/streaming flags, suggestions, and context facts.
// SPRINT: 4

import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

// Sentinel used to distinguish "not passed" from "explicitly null" in copyWith.
const _kSentinel = Object();

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? error;
  final bool isOffline;
  final List<String> suggestions;
  final String? streamingMessageId;
  final Map<String, String> contextFacts;
  final bool isRateLimited;
  final String? rateLimitWarningText;
  final bool isTimeout;

  const ChatState({
    this.messages = const [],
    this.isTyping = false,
    this.error,
    this.isOffline = false,
    this.suggestions = const [],
    this.streamingMessageId,
    this.contextFacts = const {},
    this.isRateLimited = false,
    this.rateLimitWarningText,
    this.isTimeout = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? error,
    bool clearError = false,
    bool? isOffline,
    List<String>? suggestions,
    Object? streamingMessageId = _kSentinel,
    Map<String, String>? contextFacts,
    bool? isRateLimited,
    Object? rateLimitWarningText = _kSentinel,
    bool? isTimeout,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: clearError ? null : error ?? this.error,
      isOffline: isOffline ?? this.isOffline,
      suggestions: suggestions ?? this.suggestions,
      streamingMessageId: identical(streamingMessageId, _kSentinel)
          ? this.streamingMessageId
          : streamingMessageId as String?,
      contextFacts: contextFacts ?? this.contextFacts,
      isRateLimited: isRateLimited ?? this.isRateLimited,
      rateLimitWarningText: identical(rateLimitWarningText, _kSentinel)
          ? this.rateLimitWarningText
          : rateLimitWarningText as String?,
      isTimeout: isTimeout ?? this.isTimeout,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        isTyping,
        error,
        isOffline,
        suggestions,
        streamingMessageId,
        contextFacts,
        isRateLimited,
        rateLimitWarningText,
        isTimeout,
      ];
}
