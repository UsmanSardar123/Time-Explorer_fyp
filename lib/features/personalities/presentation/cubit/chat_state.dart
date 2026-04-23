import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? error;
  final bool isOffline;

  const ChatState({
    this.messages = const [],
    this.isTyping = false,
    this.error,
    this.isOffline = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? error,
    bool clearError = false,
    bool? isOffline,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: clearError ? null : error ?? this.error,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [messages, isTyping, error, isOffline];
}
