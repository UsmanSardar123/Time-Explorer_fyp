// FILE: lib/features/personalities/presentation/widgets/message_bubble.dart
// PURPOSE: User and character chat bubbles with parchment texture, markdown, streaming cursor, and context card.
// SPRINT: 4

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import '../../data/services/analytics_service.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final Character character;
  final bool isStreaming;
  final Map<String, String> contextFacts;

  const MessageBubble({
    super.key,
    required this.message,
    required this.character,
    required this.isStreaming,
    this.contextFacts = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (message.isUser) return _UserBubble(text: message.text);
    return _CharacterBubble(
      text: message.text,
      character: character,
      isStreaming: isStreaming,
      contextFacts: contextFacts,
    );
  }
}

// ── User bubble ───────────────────────────────────────────────────────────────

class _UserBubble extends StatelessWidget {
  final String text;
  const _UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 60),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.beVietnamPro(
              fontSize: 14, color: Colors.white, height: 1.45),
        ),
      ),
    );
  }
}

// ── Character bubble ──────────────────────────────────────────────────────────

class _CharacterBubble extends StatelessWidget {
  final String text;
  final Character character;
  final bool isStreaming;
  final Map<String, String> contextFacts;

  const _CharacterBubble({
    required this.text,
    required this.character,
    required this.isStreaming,
    required this.contextFacts,
  });

  // Returns (keyword, fact) or null.
  (String, String)? _matchFact() {
    if (contextFacts.isEmpty || text.isEmpty) return null;
    final lower = text.toLowerCase();
    for (final e in contextFacts.entries) {
      if (lower.contains(e.key.toLowerCase())) return (e.key, e.value);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final match = _matchFact();
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ChatMiniAvatar(imageUrl: character.imageUrl),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12, right: 60),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFDF6E3), Color(0xFFF5E6C8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(
                    color: const Color(0xFFD4A853).withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BubbleContent(text: text, isStreaming: isStreaming),
                  if (match != null)
                    _ContextCard(
                      fact: match.$2,
                      keyword: match.$1,
                      characterId: character.id,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bubble content (markdown + cursor) ───────────────────────────────────────

class _BubbleContent extends StatelessWidget {
  final String text;
  final bool isStreaming;
  const _BubbleContent({required this.text, required this.isStreaming});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 13, 18, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            data: text,
            styleSheet: MarkdownStyleSheet(
              p: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: const Color(0xFF3D2C0E),
                height: 1.55,
              ),
              strong: GoogleFonts.beVietnamPro(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF3D2C0E),
              ),
            ),
          ),
          if (isStreaming) const _StreamingCursor(),
        ],
      ),
    );
  }
}

// ── Streaming cursor ──────────────────────────────────────────────────────────

class _StreamingCursor extends StatefulWidget {
  const _StreamingCursor();

  @override
  State<_StreamingCursor> createState() => _StreamingCursorState();
}

class _StreamingCursorState extends State<_StreamingCursor> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500),
        (_) { if (mounted) setState(() => _visible = !_visible); });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 80),
      child: Container(
        width: 2,
        height: 16,
        margin: const EdgeInsets.only(left: 2, top: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF8B6914),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}

// ── Historical context card ───────────────────────────────────────────────────

class _ContextCard extends StatefulWidget {
  final String fact;
  final String keyword;
  final String characterId;
  const _ContextCard({
    required this.fact,
    required this.keyword,
    required this.characterId,
  });

  @override
  State<_ContextCard> createState() => _ContextCardState();
}

class _ContextCardState extends State<_ContextCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: const Color(0xFFD4A853).withValues(alpha: 0.3))),
      ),
      child: InkWell(
        onTap: () {
          if (!_expanded) {
            AnalyticsService.logContextCardExpanded(
              characterId: widget.characterId,
              keyword: widget.keyword,
            );
          }
          setState(() => _expanded = !_expanded);
        },
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('📜', style: TextStyle(fontSize: 11)),
                  const SizedBox(width: 6),
                  Text(
                    'Historical Context',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF8B6914),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF8B6914),
                    size: 16,
                  ),
                ],
              ),
              if (_expanded)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    widget.fact,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: const Color(0xFF5C4010),
                      height: 1.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared mini avatar ────────────────────────────────────────────────────────

class ChatMiniAvatar extends StatelessWidget {
  final String imageUrl;
  const ChatMiniAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppTheme.surfaceLow,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          httpHeaders: const {'User-Agent': 'TimeExplorer/1.0 (Flutter)'},
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => const Icon(
            Icons.person_rounded,
            color: AppTheme.onSurfaceVariant,
            size: 16,
          ),
        ),
      ),
    );
  }
}
