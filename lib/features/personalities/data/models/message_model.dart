import '../../domain/entities/chat_message.dart';

class MessageModel {
  final int? id;
  final String characterId;
  final String role;
  final String content;
  final int timestamp;

  const MessageModel({
    this.id,
    required this.characterId,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'characterId': characterId,
        'role': role,
        'content': content,
        'timestamp': timestamp,
      };

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
        id: map['id'] as int?,
        characterId: map['characterId'] as String,
        role: map['role'] as String,
        content: map['content'] as String,
        timestamp: map['timestamp'] as int,
      );

  ChatMessage toChatMessage() => ChatMessage(
        id: '${characterId}_$timestamp',
        text: content,
        isUser: role == 'user',
      );
}
