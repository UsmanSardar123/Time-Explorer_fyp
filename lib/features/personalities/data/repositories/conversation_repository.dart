// FILE: lib/features/personalities/data/repositories/conversation_repository.dart
// PURPOSE: Firestore persistence for chat messages + API-based session summary generation.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:timeexplorer/core/services/api_service.dart';
import '../../domain/entities/character.dart';
import '../models/message_model.dart';
import '../services/conversation_manager.dart';

class ConversationRepository {
  static const int _messageLoadLimit = 20;

  final FirebaseFirestore _firestore;

  ConversationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? _messagesRef(String characterId) {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('conversations')
        .doc(characterId)
        .collection('messages');
  }

  DocumentReference<Map<String, dynamic>>? _conversationDoc(String characterId) {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('conversations')
        .doc(characterId);
  }

  Future<void> initSession(String characterId, ConversationManager manager) async {
    try {
      await Future.wait([
        _loadMessages(characterId, manager),
        _loadSummary(characterId, manager),
      ]);
    } catch (e) {
      debugPrint('[ConversationRepo] initSession failed: $e');
    }
  }

  Future<void> _loadMessages(String characterId, ConversationManager manager) async {
    final ref = _messagesRef(characterId);
    if (ref == null) return;
    try {
      final snap = await ref
          .orderBy('timestamp', descending: true)
          .limit(_messageLoadLimit)
          .get();
      final messages = snap.docs
          .map((d) => MessageModel.fromFirestore(d.data()))
          .toList()
          .reversed
          .toList();
      manager.loadMessages(messages);
    } catch (e) {
      debugPrint('[ConversationRepo] _loadMessages failed: $e');
    }
  }

  Future<void> _loadSummary(String characterId, ConversationManager manager) async {
    final doc = _conversationDoc(characterId);
    if (doc == null) return;
    try {
      final snap = await doc.get();
      if (!snap.exists) return;
      final summary = snap.data()?['lastSessionSummary'] as String?;
      manager.setSessionSummary(summary);
    } catch (e) {
      debugPrint('[ConversationRepo] _loadSummary failed: $e');
    }
  }

  // Fire-and-forget — never awaited in the hot path.
  void saveMessage(MessageModel message) {
    final ref = _messagesRef(message.characterId);
    if (ref == null) return;
    ref.doc(message.messageId).set(message.toFirestore()).catchError((e) {
      debugPrint('[ConversationRepo] saveMessage failed (non-fatal): $e');
    });
  }

  Future<void> endSession(Character character, List<MessageModel> messages) async {
    if (messages.isEmpty) return;
    final doc = _conversationDoc(character.id);
    if (doc == null) return;
    try {
      final summary = await _generateSummary(character, messages);
      if (summary.isNotEmpty) {
        await doc.set({'lastSessionSummary': summary}, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('[ConversationRepo] endSession failed (non-fatal): $e');
    }
  }

  Future<String> _generateSummary(Character character, List<MessageModel> messages) async {
    final transcript = messages
        .map((m) => '${m.role == MessageRole.user ? "User" : character.name}: ${m.content}')
        .join('\n');

    final prompt = 'Summarize this conversation in 3 sentences from '
        "${character.name}'s perspective. Write in first person as "
        '${character.name}.\n\n$transcript';

    try {
      final api = ApiService();
      final data = await api.post('/ai/ask', {'prompt': prompt});
      return (data['response'] as String? ?? '').trim();
    } catch (e) {
      debugPrint('[ConversationRepo] _generateSummary failed: $e');
      return '';
    }
  }
}
