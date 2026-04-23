import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/chat_message.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

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
        _scroll.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
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
          child: _ChatAppBar(character: widget.character),
        ),
        body: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            if (!state.isTyping) _scrollToBottom();
          },
          builder: (context, state) => Column(
            children: [
              if (state.isOffline) const _OfflineBanner(),
              Expanded(
                child: _MessageList(
                  messages: state.messages,
                  isTyping: state.isTyping,
                  error: state.error,
                  character: widget.character,
                  scrollController: _scroll,
                ),
              ),
              _InputRow(
                controller: _input,
                onSend: _send,
                character: widget.character,
                isDisabled: state.isOffline || state.isTyping,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget {
  final Character character;
  const _ChatAppBar({required this.character});

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
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.onSurface, size: 18),
            onPressed: () => context.pop(),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.surfaceLow,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: character.imageUrl,
                httpHeaders: const {'User-Agent': 'TimeExplorer/1.0 (Flutter)'},
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Icon(Icons.person_rounded, color: AppTheme.onSurfaceVariant, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  character.name,
                  style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.onSurface),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF059669)),
                    ),
                    const SizedBox(width: 5),
                    Text('Online', style: GoogleFonts.beVietnamPro(fontSize: 11, color: AppTheme.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryContainer.withValues(alpha: 0.20)),
              ),
              child: Text(
                'AI',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.primaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? error;
  final Character character;
  final ScrollController scrollController;

  const _MessageList({
    required this.messages,
    required this.isTyping,
    required this.error,
    required this.character,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final reversed = messages.reversed.toList();
    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      physics: const BouncingScrollPhysics(),
      itemCount: reversed.length + (isTyping ? 1 : 0) + (error != null ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == 0 && error != null) return _ErrorBubble(message: error!);
        if (i == (error != null ? 1 : 0) && isTyping) return _TypingBubble(character: character);
        final offset = (isTyping ? 1 : 0) + (error != null ? 1 : 0);
        final msg = reversed[i - offset];
        return _MessageBubble(message: msg, character: character);
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final Character character;
  const _MessageBubble({required this.message, required this.character});

  @override
  Widget build(BuildContext context) {
    return message.isUser
        ? _UserBubble(text: message.text)
        : _AiBubble(text: message.text, character: character);
  }
}

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
          style: GoogleFonts.beVietnamPro(fontSize: 14, color: Colors.white, height: 1.45),
        ),
      ),
    );
  }
}

class _AiBubble extends StatelessWidget {
  final String text;
  final Character character;
  const _AiBubble({required this.text, required this.character});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _MiniAvatar(imageUrl: character.imageUrl),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12, right: 60),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLowest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: Text(
                text,
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppTheme.onSurface, height: 1.55),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  final String imageUrl;
  const _MiniAvatar({required this.imageUrl});

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
          errorWidget: (_, __, ___) => const Icon(Icons.person_rounded, color: AppTheme.onSurfaceVariant, size: 16),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  final Character character;
  const _TypingBubble({required this.character});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _MiniAvatar(imageUrl: character.imageUrl),
          const SizedBox(width: 10),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLowest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppTheme.outlineVariant),
            ),
            child: const _BouncingDots(),
          ),
        ],
      ),
    );
  }
}

class _BouncingDots extends StatefulWidget {
  const _BouncingDots();

  @override
  State<_BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<_BouncingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final start = i * 0.2;
        final end = (start + 0.4).clamp(0.0, 1.0);
        final anim = Tween<double>(begin: 0.0, end: -7.0).animate(
          CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeInOut)),
        );
        return AnimatedBuilder(
          animation: anim,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, anim.value),
            child: Container(
              margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryContainer.withValues(alpha: 0.5),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppTheme.primaryContainer.withValues(alpha: 0.12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 14, color: AppTheme.primaryContainer),
          const SizedBox(width: 6),
          Text(
            'You\'re offline — showing cached messages',
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: AppTheme.primaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

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
            child: Text(
              message,
              style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppTheme.error, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

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
      padding: EdgeInsets.fromLTRB(16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
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
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppTheme.onSurface),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Ask ${character.name.split(' ').first}…',
                  hintStyle: GoogleFonts.beVietnamPro(fontSize: 14, color: AppTheme.outlineVariant),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
          child: Icon(
            Icons.send_rounded,
            color: widget.isDisabled ? AppTheme.onSurfaceVariant : Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
