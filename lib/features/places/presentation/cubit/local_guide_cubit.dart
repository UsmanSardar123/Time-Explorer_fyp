// FILE: lib/features/places/presentation/cubit/local_guide_cubit.dart
// PURPOSE: Manages Talk to Local guide chat session with Gemini streaming and sliding window history.
// SPRINT: local-guide

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/local_guide_prompt_builder.dart';
import '../../data/services/local_guide_service.dart';
import '../../domain/entities/place.dart';
import 'local_guide_state.dart';

class LocalGuideCubit extends Cubit<LocalGuideState> {
  final Place _place;
  final LocalGuideService _service;
  final String _systemPrompt;
  final List<Map<String, String>> _history = [];

  // Keep 8 user+guide exchanges (16 turns) in context.
  static const int _windowSize = 16;

  LocalGuideCubit({required Place place})
      : _place = place,
        _service = const LocalGuideService(),
        _systemPrompt = LocalGuidePromptBuilder.build(place),
        super(LocalGuideState(
          messages: [
            LocalGuideMessage(
              id: 'welcome',
              text: 'Ask me anything about ${place.name}.',
              isUser: false,
            ),
          ],
        ));

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userId = 'u_${DateTime.now().millisecondsSinceEpoch}';
    _history.add({'role': 'user', 'content': trimmed});

    emit(state.copyWith(
      messages: [
        ...state.messages,
        LocalGuideMessage(id: userId, text: trimmed, isUser: true),
      ],
      isTyping: true,
      clearError: true,
    ));

    final aiId = 'a_${DateTime.now().millisecondsSinceEpoch}';
    String fullReply = '';
    bool firstChunk = true;

    try {
      final window = _history.length > _windowSize
          ? _history.sublist(_history.length - _windowSize)
          : List<Map<String, String>>.from(_history);

      final stream = _service.sendStream(
        systemPrompt: _systemPrompt,
        history: window,
      );

      await for (final chunk in stream) {
        fullReply += chunk;
        if (firstChunk) {
          firstChunk = false;
          emit(state.copyWith(
            messages: [
              ...state.messages,
              LocalGuideMessage(id: aiId, text: fullReply, isUser: false),
            ],
            isTyping: false,
            streamingId: aiId,
          ));
        } else {
          final updated = List<LocalGuideMessage>.from(state.messages);
          final idx = updated.indexWhere((m) => m.id == aiId);
          if (idx != -1) {
            updated[idx] = updated[idx].copyWithText(fullReply);
            emit(state.copyWith(messages: updated));
          }
        }
      }

      _history.add({'role': 'model', 'content': fullReply});
      emit(state.copyWith(clearStreaming: true));
    } catch (e) {
      _history.removeLast();
      debugPrint('[LocalGuideCubit] error: $e');

      final msgs = List<LocalGuideMessage>.from(state.messages);
      if (!firstChunk) msgs.removeWhere((m) => m.id == aiId);

      emit(state.copyWith(
        messages: msgs,
        isTyping: false,
        clearStreaming: true,
        error: 'Something went wrong. Please try again.',
      ));
    }
  }

  String get placeName => _place.name;
  String get placeLocation => _place.location;
  String get placeImageUrl => _place.imageUrl;
}
