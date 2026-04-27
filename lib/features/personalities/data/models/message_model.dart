// FILE: lib/features/personalities/data/models/message_model.dart
// PURPOSE: Chat message data model with UUID identity and dual-backend serialization.
// SPRINT: 1-2

import 'package:uuid/uuid.dart';
import '../../domain/entities/chat_message.dart';

enum MessageRole { user, character }

class MessageModel {
  final int? id;           // SQLite auto-id (nullable for new records)
  final String messageId; // UUID — primary key for Firestore
  final String characterId;
  final MessageRole role;
  final String content;
  final int timestamp; // milliseconds since epoch

  const MessageModel({
    this.id,
    required this.messageId,
    required this.characterId,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);

  String get roleString => role == MessageRole.user ? 'user' : 'model';

  factory MessageModel.create({
    required String characterId,
    required MessageRole role,
    required String content,
  }) =>
      MessageModel(
        messageId: const Uuid().v4(),
        characterId: characterId,
        role: role,
        content: content,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

  // ── SQLite ────────────────────────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'messageId': messageId,
        'characterId': characterId,
        'role': role.name,
        'content': content,
        'timestamp': timestamp,
      };

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
        id: map['id'] as int?,
        messageId: map['messageId'] as String? ??
            '${map['characterId']}_${map['timestamp']}',
        characterId: map['characterId'] as String,
        role: _roleFromString(map['role'] as String? ?? 'user'),
        content: map['content'] as String,
        timestamp: map['timestamp'] as int,
      );

  // ── Firestore ─────────────────────────────────────────────────────────────

  Map<String, dynamic> toFirestore() => {
        'messageId': messageId,
        'characterId': characterId,
        'role': role.name,
        'content': content,
        'timestamp': timestamp,
      };

  factory MessageModel.fromFirestore(Map<String, dynamic> data) => MessageModel(
        messageId:
            data['messageId'] as String? ?? data['id'] as String? ?? '',
        characterId: data['characterId'] as String,
        role: _roleFromString(data['role'] as String? ?? 'user'),
        content: data['content'] as String,
        timestamp: data['timestamp'] as int,
      );

  static MessageRole _roleFromString(String role) =>
      (role == 'character' || role == 'model')
          ? MessageRole.character
          : MessageRole.user;

  ChatMessage toChatMessage() => ChatMessage(
        id: messageId,
        text: content,
        isUser: role == MessageRole.user,
      );
}
