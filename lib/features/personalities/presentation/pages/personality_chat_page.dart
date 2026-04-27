// FILE: lib/features/personalities/presentation/pages/personality_chat_page.dart
// PURPOSE: Chat screen with character header, streaming messages, suggestion chips, and context cards.
// SPRINT: 5

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import '../../data/services/analytics_service.dart';
import '../../domain/entities/character.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/suggestion_chips.dart';
import '../widgets/typing_indicator.dart';

class PersonalityChatPage extends StatefulWidget {
  final Character character;
  const PersonalityChatPage({super.key, required this.character});

  @override
  State<PersonalityChatPage> createState() => _PersonalityChatPageState();
}

class _PersonalityChatPageState extends State<PersonalityChatPage> {
  late final ChatCubit _cubit;
  final _scroll = ScrollController();
  final _input = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = ChatCubit(character: widget.character);
  }

  @override
  void dispose() {
    _cubit.close();
    _scroll.dispose();
    _input.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    context.read<GamificationProvider>().recordMessageSent();
    _cubit.sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: _ChatHeader(character: widget.character),
        ),
        body: BlocConsumer<ChatCubit, ChatState>(
          listenWhen: (prev, curr) =>
              (prev.isTyping && !curr.isTyping) ||
              (prev.streamingMessageId != null &&
                  curr.streamingMessageId == null) ||
              (prev.rateLimitWarningText != curr.rateLimitWarningText) ||
              (prev.isRateLimited != curr.isRateLimited) ||
              (!prev.isTimeout && curr.isTimeout),
          listener: (ctx, state) {
            if (!state.isTyping && state.streamingMessageId == null) {
              _scrollToBottom();
            }
            if (state.isTimeout) {
              ScaffoldMessenger.of(ctx)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(
                    'The scroll is taking too long to unroll. Tap below to try again.',
                    style: GoogleFonts.beVietnamPro(fontSize: 13),
                  ),
                  backgroundColor: const Color(0xFF5C4010),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(16),
                  duration: const Duration(seconds: 4),
                ));
            }
            if (state.rateLimitWarningText != null && !state.isRateLimited) {
              ScaffoldMessenger.of(ctx)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(
                    state.rateLimitWarningText!,
                    style: GoogleFonts.beVietnamPro(fontSize: 13),
                  ),
                  backgroundColor: const Color(0xFF8B6914),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(16),
                ));
            }
            if (state.isRateLimited) {
              showDialog<void>(
                context: ctx,
                barrierDismissible: false,
                builder: (_) =>
                    _RateLimitDialog(character: widget.character),
              );
            }
          },
          builder: (_, state) => _ChatBody(
            character: widget.character,
            state: state,
            scroll: _scroll,
            input: _input,
            onSend: _send,
            onRetry: _cubit.retryLastMessage,
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _ChatHeader extends StatelessWidget {
  final Character character;
  const _ChatHeader({required this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLowest,
        border: Border(bottom: BorderSide(color: AppTheme.outlineVariant)),
      ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppTheme.onSurface, size: 18),
            onPressed: () => context.pop(),
          ),
          _HeaderAvatar(imageUrl: character.imageUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(character.name,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface)),
                Row(
                  children: [
                    const _LiveDot(),
                    const SizedBox(width: 5),
                    Text('Live',
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 11, color: AppTheme.onSurfaceVariant)),
                    const SizedBox(width: 8),
                    _EraBadge(era: character.era),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  final String imageUrl;
  const _HeaderAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppTheme.surfaceLow,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          httpHeaders: const {'User-Agent': 'TimeExplorer/1.0 (Flutter)'},
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => const Icon(Icons.person_rounded,
              color: AppTheme.onSurfaceVariant, size: 20),
        ),
      ),
    );
  }
}

class _EraBadge extends StatelessWidget {
  final String era;
  const _EraBadge({required this.era});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: const Color(0xFFD4A853).withValues(alpha: 0.45)),
      ),
      child: Text(
        era,
        style: GoogleFonts.plusJakartaSans(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8B6914)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.35, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, _) => Opacity(
        opacity: _opacity.value,
        child: Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Color(0xFF059669)),
        ),
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _ChatBody extends StatelessWidget {
  final Character character;
  final ChatState state;
  final ScrollController scroll;
  final TextEditingController input;
  final VoidCallback onSend;
  final VoidCallback onRetry;

  const _ChatBody({
    required this.character,
    required this.state,
    required this.scroll,
    required this.input,
    required this.onSend,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final display = state.messages
        .where((m) => m.isUser || m.text.isNotEmpty)
        .toList();
    final reversed = display.reversed.toList();
    final hasError = state.error != null;
    final hasTimeout = state.isTimeout;
    final extraCount =
        (state.isTyping ? 1 : 0) + (hasError ? 1 : 0) + (hasTimeout ? 1 : 0);

    return Column(
      children: [
        if (state.isOffline) const _OfflineBanner(),
        Expanded(
          child: CustomScrollView(
            controller: scroll,
            reverse: true,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      if (i == 0 && hasTimeout) {
                        return _TimeoutRetryCard(onRetry: onRetry);
                      }
                      final afterTimeout = hasTimeout ? 1 : 0;
                      if (i == afterTimeout && hasError) {
                        return _ErrorBubble(message: state.error!);
                      }
                      if (i == afterTimeout + (hasError ? 1 : 0) &&
                          state.isTyping) {
                        return TypingIndicator(imageUrl: character.imageUrl);
                      }
                      final msg = reversed[i - extraCount];
                      return MessageBubble(
                        key: ValueKey(msg.id),
                        message: msg,
                        character: character,
                        isStreaming: msg.id == state.streamingMessageId,
                        contextFacts: state.contextFacts,
                      );
                    },
                    childCount: reversed.length + extraCount,
                  ),
                ),
              ),
            ],
          ),
        ),
        SuggestionChips(
          suggestions: state.suggestions,
          onChipTapped: (text) {
            unawaited(AnalyticsService.logSuggestionChipTapped(
              characterId: character.id,
              chipText: text,
            ));
            input.text = text;
            onSend();
          },
        ),
        _InputRow(
          controller: input,
          onSend: onSend,
          character: character,
          isDisabled:
              state.isTyping || state.isOffline || state.isRateLimited,
        ),
      ],
    );
  }
}

// ── Offline banner ────────────────────────────────────────────────────────────

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppTheme.primaryContainer.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded,
              size: 14, color: AppTheme.primaryContainer),
          const SizedBox(width: 6),
          Text('You\'re offline — showing cached messages',
              style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  color: AppTheme.primaryContainer,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ── Error bubble ──────────────────────────────────────────────────────────────

class _ErrorBubble extends StatelessWidget {
  final String message;
  const _ErrorBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppTheme.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: GoogleFonts.beVietnamPro(
                    fontSize: 12, color: AppTheme.error, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

// ── Timeout retry card ────────────────────────────────────────────────────────

class _TimeoutRetryCard extends StatelessWidget {
  final VoidCallback onRetry;
  const _TimeoutRetryCard({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRetry,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD4A853).withValues(alpha: 0.45)),
        ),
        child: Row(
          children: [
            const Icon(Icons.hourglass_empty_rounded,
                color: Color(0xFF8B6914), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'The scroll is taking too long to unroll. Tap to retry.',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    color: const Color(0xFF5C4010),
                    height: 1.4),
              ),
            ),
            const Icon(Icons.refresh_rounded,
                color: Color(0xFF8B6914), size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Input row ─────────────────────────────────────────────────────────────────

class _InputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final Character character;
  final bool isDisabled;

  const _InputRow({
    required this.controller,
    required this.onSend,
    required this.character,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLowest,
        border: Border(top: BorderSide(color: AppTheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLow,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: TextField(
                controller: controller,
                style: GoogleFonts.beVietnamPro(
                    fontSize: 14, color: AppTheme.onSurface),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Ask ${character.name.split(' ').first}…',
                  hintStyle: GoogleFonts.beVietnamPro(
                      fontSize: 14, color: AppTheme.outlineVariant),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _SendButton(onTap: onSend, isDisabled: isDisabled),
        ],
      ),
    );
  }
}

// ── Rate limit dialog ─────────────────────────────────────────────────────────

class _RateLimitDialog extends StatelessWidget {
  final Character character;
  const _RateLimitDialog({required this.character});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFDF6E3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          ChatMiniAvatar(imageUrl: character.imageUrl),
          const SizedBox(width: 10),
          Text(character.name,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3D2C0E))),
        ],
      ),
      content: Text(
        character.rateLimitWarning.isNotEmpty
            ? character.rateLimitWarning
            : 'You have asked me many questions today. Return on the morrow '
                'and we shall continue our discourse.',
        style: GoogleFonts.beVietnamPro(
            fontSize: 14, color: const Color(0xFF5C4010), height: 1.55),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text('Return later',
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8B6914))),
        ),
      ],
    );
  }
}

// ── Send button ───────────────────────────────────────────────────────────────

class _SendButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isDisabled;
  const _SendButton({required this.onTap, this.isDisabled = false});

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isDisabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.isDisabled
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onTap();
            },
      onTapCancel: widget.isDisabled ? null : () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: widget.isDisabled ? null : AppTheme.primaryGradient,
            color: widget.isDisabled ? AppTheme.outlineVariant : null,
            boxShadow: widget.isDisabled
                ? null
                : [
                    BoxShadow(
                      color: AppTheme.primaryContainer.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Icon(Icons.send_rounded,
              color: widget.isDisabled ? AppTheme.onSurfaceVariant : Colors.white,
              size: 20),
        ),
      ),
    );
  }
}
