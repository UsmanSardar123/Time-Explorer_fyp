// FILE: lib/features/places/presentation/cubit/local_guide_state.dart
// PURPOSE: Immutable state for the Talk to Local guide chat cubit.
// SPRINT: local-guide

import 'package:equatable/equatable.dart';

class LocalGuideMessage extends Equatable {
  final String id;
  final String text;
  final bool isUser;

  const LocalGuideMessage({
    required this.id,
    required this.text,
    required this.isUser,
  });

  LocalGuideMessage copyWithText(String text) =>
      LocalGuideMessage(id: id, text: text, isUser: isUser);

  @override
  List<Object?> get props => [id, text, isUser];
}

class LocalGuideState extends Equatable {
  final List<LocalGuideMessage> messages;
  final bool isTyping;
  final String? streamingId;
  final String? error;

  const LocalGuideState({
    this.messages = const [],
    this.isTyping = false,
    this.streamingId,
    this.error,
  });

  LocalGuideState copyWith({
    List<LocalGuideMessage>? messages,
    bool? isTyping,
    String? streamingId,
    bool clearStreaming = false,
    String? error,
    bool clearError = false,
  }) {
    return LocalGuideState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      streamingId: clearStreaming ? null : (streamingId ?? this.streamingId),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [messages, isTyping, streamingId, error];
}
