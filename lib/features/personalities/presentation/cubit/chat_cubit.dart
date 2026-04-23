import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/chat_local_data_source.dart';
import '../../data/models/message_model.dart';
import '../../data/services/chat_prompt_builder.dart';
import '../../data/services/openai_chat_service.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/chat_message.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final OpenAIChatService _service;
  final Character _character;
  final ChatLocalDataSource _db;
  final List<Map<String, String>> _history = [];

  ChatCubit({required Character character})
      : _service = const OpenAIChatService(),
        _character = character,
        _db = ChatLocalDataSource(),
        super(const ChatState()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final saved = await _db.getMessagesByCharacter(_character.id);
      if (saved.isEmpty) {
        emit(state.copyWith(messages: [
          ChatMessage(
            id: 'greeting',
            text: 'Greetings. I am ${_character.name}. '
                'What would you like to discuss?',
            isUser: false,
          ),
        ]));
      } else {
        _history.addAll(
          saved.map((m) => {'role': m.role, 'content': m.content}),
        );
        emit(state.copyWith(
            messages: saved.map((m) => m.toChatMessage()).toList()));
      }
    } catch (e) {
      debugPrint('[ChatCubit] DB load failed, starting fresh: $e');
      emit(state.copyWith(messages: [
        ChatMessage(
          id: 'greeting',
          text: 'Greetings. I am ${_character.name}. '
              'What would you like to discuss?',
          isUser: false,
        ),
      ]));
    }
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _history.add({'role': 'user', 'content': trimmed});

    emit(state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(
          id: '${DateTime.now().millisecondsSinceEpoch}',
          text: trimmed,
          isUser: true,
        ),
      ],
      isTyping: true,
      clearError: true,
      isOffline: false,
    ));

    try {
      final reply = await _service.send(
        character: _character,
        systemPrompt: ChatPromptBuilder.build(_character),
        history: List.from(_history),
      );

      _history.add({'role': 'model', 'content': reply});

      final now = DateTime.now().millisecondsSinceEpoch;

      // Persist to DB — failure here must NOT block the AI reply from showing.
      try {
        await _db.insertMessage(MessageModel(
          characterId: _character.id,
          role: 'user',
          content: trimmed,
          timestamp: now - 1,
        ));
        await _db.insertMessage(MessageModel(
          characterId: _character.id,
          role: 'model',
          content: reply,
          timestamp: now,
        ));
      } catch (dbErr) {
        debugPrint('[ChatCubit] DB save failed (non-fatal): $dbErr');
      }

      emit(state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(id: '${now}_ai', text: reply, isUser: false),
        ],
        isTyping: false,
      ));
    } catch (e) {
      _history.removeLast();
      final errStr = e.toString();
      // Avoid dart:io SocketException — use string matching for web compatibility.
      final isNetworkError = errStr.contains('SocketException') ||
          errStr.contains('Failed host lookup') ||
          errStr.contains('Network is unreachable') ||
          errStr.contains('XMLHttpRequest error');
      emit(state.copyWith(
        isTyping: false,
        error: errStr,
        isOffline: isNetworkError,
      ));
    }
  }

  Future<void> clearHistory() async {
    try {
      await _db.clearMessages(_character.id);
    } catch (e) {
      debugPrint('[ChatCubit] DB clear failed (non-fatal): $e');
    }
    _history.clear();
    emit(state.copyWith(messages: [
      ChatMessage(
        id: 'greeting',
        text: 'Greetings. I am ${_character.name}. '
            'What would you like to discuss?',
        isUser: false,
      ),
    ]));
  }
}
