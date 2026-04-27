// FILE: lib/features/personalities/presentation/widgets/typing_indicator.dart
// PURPOSE: Three-dot typing animation with staggered scale and opacity, shown before first stream chunk.
// SPRINT: 4

import 'package:flutter/material.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'message_bubble.dart' show ChatMiniAvatar;

class TypingIndicator extends StatefulWidget {
  final String imageUrl;
  const TypingIndicator({super.key, required this.imageUrl});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ChatMiniAvatar(imageUrl: widget.imageUrl),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, _buildDot),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int i) {
    final start = i * (150.0 / 900.0);
    final end = (start + 0.4).clamp(0.0, 1.0);
    final curve = Interval(start, end, curve: Curves.easeInOut);
    final scale = Tween<double>(begin: 1.0, end: 1.45)
        .animate(CurvedAnimation(parent: _ctrl, curve: curve));
    final opacity = Tween<double>(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: curve));
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: opacity.value,
        child: Transform.scale(
          scale: scale.value,
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 5.0 : 0),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryContainer.withValues(alpha: 0.55),
            ),
          ),
        ),
      ),
    );
  }
}
