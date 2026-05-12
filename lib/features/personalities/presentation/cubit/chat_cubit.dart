// FILE: lib/features/personalities/presentation/cubit/chat_cubit.dart
// PURPOSE: Chat session cubit — wires rate limiting, response caching, streaming, and analytics.
// SPRINT: 5

import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeexplorer/core/services/gemini_service.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/conversation_repository.dart';
import '../../data/services/analytics_service.dart';
import '../../data/services/chat_prompt_builder.dart';
import '../../data/services/context_fact_service.dart';
import '../../data/services/conversation_manager.dart';
import '../../data/services/openai_chat_service.dart';
import '../../data/services/prompt_builder_service.dart';
import '../../data/services/rate_limit_service.dart';
import '../../data/services/response_cache_service.dart';
import '../../data/services/response_validator.dart';
import '../../data/repositories/character_firestore_repository.dart';
import '../../data/services/suggestion_service.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/chat_message.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final OpenAIChatService _service;
  Character _character;
  final ConversationManager _manager;
  final CharacterFirestoreRepository _firestoreRepo;
  final ConversationRepository _repo;
  final PromptBuilderService _promptBuilder;
  final SuggestionService _suggestionService;
  final ContextFactService _contextFactService;
  final RateLimitService _rateLimitService;
  final ResponseCacheService _cacheService;

  String? _pendingRetryText;

  ChatCubit({required Character character})
      : _service = const OpenAIChatService(),
        _character = character,
        _manager = ConversationManager(),
        _repo = ConversationRepository(),
        _promptBuilder = const PromptBuilderService(),
        _suggestionService = const SuggestionService(),
        _contextFactService = ContextFactService(),
        _rateLimitService = RateLimitService(),
        _cacheService = ResponseCacheService(),
        _firestoreRepo = CharacterFirestoreRepository(),
        super(const ChatState()) {
    _initSession();
  }

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> _initSession() async {
    final firestoreChar = await _firestoreRepo.getById(_character.id);
    if (firestoreChar != null) _character = firestoreChar;
    _manager.setSystemPrompt(_promptBuilder.build(_character));

    unawaited(AnalyticsService.logChatSessionStarted(
      characterId: _character.id,
      userId: _uid,
    ));

    final results = await Future.wait([
      _repo.initSession(_character.id, _manager).then((_) => null),
      _contextFactService.getContextFacts(_character.id),
    ]);

    final contextFacts = results[1] as Map<String, String>;

    if (_manager.hasMessages) {
      emit(state.copyWith(
        messages: _manager.getHistory().map((m) => m.toChatMessage()).toList(),
        contextFacts: contextFacts,
      ));
    } else {
      emit(state.copyWith(messages: [_greeting()], contextFacts: contextFacts));
    }
  }

  Future<void> retryLastMessage() async {
    final retryText = _pendingRetryText;
    if (retryText == null || retryText.isEmpty) return;
    _pendingRetryText = null;
    // Remove the failed user message from conversation manager and UI state.
    _manager.removeLastMessage();
    final lastUserIdx = state.messages.lastIndexWhere((m) => m.isUser);
    final withoutLastUser = lastUserIdx == -1
        ? state.messages
        : <ChatMessage>[
            ...state.messages.sublist(0, lastUserIdx),
            ...state.messages.sublist(lastUserIdx + 1),
          ];
    emit(state.copyWith(
        messages: withoutLastUser, isTimeout: false, clearError: true));
    await sendMessage(retryText);
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _pendingRetryText = trimmed;

    // ── Rate limit ───────────────────────────────────────────────────────────
    final rateResult = await _rateLimitService.checkAndIncrement(_uid);

    if (rateResult.status == RateLimitStatus.blocked) {
      emit(state.copyWith(isRateLimited: true));
      unawaited(AnalyticsService.logRateLimitHit(
          userId: _uid, characterId: _character.id));
      return;
    }

    if (rateResult.status == RateLimitStatus.warning) {
      emit(state.copyWith(
          rateLimitWarningText: _character.rateLimitWarning.isNotEmpty
              ? _character.rateLimitWarning
              : 'You are approaching your daily message limit.'));
    }

    // ── Analytics ────────────────────────────────────────────────────────────
    unawaited(AnalyticsService.logMessageSent(
      characterId: _character.id,
      messageLength: trimmed.length,
    ));

    // ── User message ─────────────────────────────────────────────────────────
    final userMsg = MessageModel.create(
      characterId: _character.id,
      role: MessageRole.user,
      content: trimmed,
    );
    _manager.addMessage(userMsg);
    _repo.saveMessage(userMsg);

    emit(state.copyWith(
      messages: [...state.messages, userMsg.toChatMessage()],
      isTyping: true,
      clearError: true,
      isOffline: false,
      isTimeout: false,
      suggestions: [],
      streamingMessageId: null,
      rateLimitWarningText: null,
    ));

    // ── Cache check ──────────────────────────────────────────────────────────
    final cached = await _cacheService.checkCache(_character.id, trimmed);
    if (cached != null) {
      final aiMsg = MessageModel.create(
        characterId: _character.id,
        role: MessageRole.character,
        content: cached,
      );
      _manager.addMessage(aiMsg);
      _repo.saveMessage(aiMsg);
      emit(state.copyWith(
        messages: [...state.messages, aiMsg.toChatMessage()],
        isTyping: false,
      ));
      unawaited(_loadSuggestions());
      return;
    }

    // ── Stream response ──────────────────────────────────────────────────────
    final aiMsgId = 'ai_${DateTime.now().millisecondsSinceEpoch}';
    bool aiAddedToState = false;
    String fullReply = '';

    try {
      final systemPrompt = _manager.systemPrompt.isNotEmpty
          ? _manager.systemPrompt
          : ChatPromptBuilder.build(_character);

      final stream = _service.sendStream(
        character: _character,
        systemPrompt: systemPrompt,
        history: _manager.getApiPayload(),
      );

      await for (final chunk in stream) {
        fullReply += chunk;
        if (!aiAddedToState) {
          aiAddedToState = true;
          emit(state.copyWith(
            messages: [
              ...state.messages,
              ChatMessage(id: aiMsgId, text: fullReply, isUser: false),
            ],
            isTyping: false,
            streamingMessageId: aiMsgId,
          ));
        } else {
          final updated = List<ChatMessage>.from(state.messages);
          final idx = updated.indexWhere((m) => m.id == aiMsgId);
          if (idx != -1) {
            updated[idx] =
                ChatMessage(id: aiMsgId, text: fullReply, isUser: false);
            emit(state.copyWith(messages: updated));
          }
        }
      }

      // ── Validate & finalise ──────────────────────────────────────────────
      final validated =
          ResponseValidator.validate(fullReply, _character.id);

      if (validated.brokenCharacter) {
        final updated = List<ChatMessage>.from(state.messages);
        final idx = updated.indexWhere((m) => m.id == aiMsgId);
        if (idx != -1) {
          updated[idx] =
              ChatMessage(id: aiMsgId, text: validated.text, isUser: false);
          emit(state.copyWith(messages: updated, streamingMessageId: null));
        } else {
          emit(state.copyWith(streamingMessageId: null));
        }
      } else {
        emit(state.copyWith(streamingMessageId: null));
        _cacheService.saveToCache(_character.id, trimmed, validated.text);
      }

      final aiMsg = MessageModel.create(
        characterId: _character.id,
        role: MessageRole.character,
        content: validated.text,
      );
      _manager.addMessage(aiMsg);
      _repo.saveMessage(aiMsg);

      unawaited(_loadSuggestions());
    } catch (e) {
      _manager.removeLastMessage();

      final currentMessages = List<ChatMessage>.from(state.messages);
      if (aiAddedToState) {
        currentMessages.removeWhere((m) => m.id == aiMsgId);
      }

      if (e is GeminiChatException &&
          _character.fallbackResponses.isNotEmpty) {
        unawaited(AnalyticsService.logGeminiFallback(
          characterId: _character.id,
          errorType: e.error.name,
        ));
        final fallbackText =
            _pickFallback(_character.fallbackResponses, e.error);
        final fallbackMsg = MessageModel.create(
          characterId: _character.id,
          role: MessageRole.character,
          content: fallbackText,
        );
        _manager.addMessage(fallbackMsg);
        _repo.saveMessage(fallbackMsg);

        emit(state.copyWith(
          messages: [...currentMessages, fallbackMsg.toChatMessage()],
          isTyping: false,
          streamingMessageId: null,
          isOffline: e.error == GeminiError.networkError,
          isTimeout: e.error == GeminiError.timeoutError,
        ));
      } else if (e is GeminiChatException &&
          e.error == GeminiError.timeoutError) {
        // No fallback responses configured — surface retry card only.
        emit(state.copyWith(
          messages: currentMessages,
          isTyping: false,
          streamingMessageId: null,
          isTimeout: true,
        ));
      } else {
        final errStr = e.toString();
        final isNetwork = errStr.contains('SocketException') ||
            errStr.contains('Failed host lookup') ||
            errStr.contains('Network is unreachable') ||
            errStr.contains('XMLHttpRequest error');
        emit(state.copyWith(
          messages: currentMessages,
          isTyping: false,
          streamingMessageId: null,
          error: errStr,
          isOffline: isNetwork,
        ));
      }
      debugPrint('[ChatCubit] sendMessage error: $e');
    }
  }

  Future<void> clearHistory() async {
    _manager.clearSession();
    emit(state.copyWith(
      messages: [_greeting()],
      suggestions: [],
      streamingMessageId: null,
    ));
  }

  Future<void> _loadSuggestions() async {
    final suggestions = await _suggestionService.getSuggestions(
      character: _character,
      recentMessages: _manager.getHistory(),
    );
    if (!isClosed) emit(state.copyWith(suggestions: suggestions));
  }

  ChatMessage _greeting() => ChatMessage(
        id: 'greeting_${_character.id}',
        text:
            'Greetings. I am ${_character.name}. What would you like to discuss?',
        isUser: false,
      );

  String _pickFallback(List<String> fallbacks, GeminiError error) {
    if (fallbacks.isEmpty) return '';
    final idx = switch (error) {
      GeminiError.networkError => 0,
      GeminiError.rateLimitError => 1 % fallbacks.length,
      GeminiError.contentFilterError => 2 % fallbacks.length,
      GeminiError.timeoutError => 0,
      GeminiError.unknownError => Random().nextInt(fallbacks.length),
    };
    return fallbacks[idx];
  }

  @override
  Future<void> close() async {
    await _repo.endSession(_character, _manager.getHistory());
    return super.close();
  }
}
