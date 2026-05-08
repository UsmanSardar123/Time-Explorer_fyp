import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

/// A friendly floating mascot that shows a short helper tip.
///
/// Use [TimeGuide.overlay] inside any screen's `Stack` (or as a `Positioned`
/// child of a `Stack` already in the tree) to surface a guide message that
/// auto-fades but stays tappable in the corner.
class TimeGuide extends StatefulWidget {
  final String message;
  final String emoji;
  final Duration autoHideAfter;
  final Alignment alignment;

  const TimeGuide({
    super.key,
    required this.message,
    this.emoji = '🦉',
    this.autoHideAfter = const Duration(seconds: 6),
    this.alignment = Alignment.bottomRight,
  });

  /// Convenience builder that wraps a [child] in a `Stack` with the guide
  /// floating at the bottom-right corner. Use as the body of a screen.
  static Widget overlay({
    required Widget child,
    required String message,
    String emoji = '🦉',
    Duration autoHideAfter = const Duration(seconds: 6),
    EdgeInsets padding = const EdgeInsets.fromLTRB(0, 0, 16, 96),
  }) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        Positioned(
          right: padding.right,
          bottom: padding.bottom,
          left: padding.left,
          top: padding.top,
          child: Align(
            alignment: Alignment.bottomRight,
            child: TimeGuide(
              message: message,
              emoji: emoji,
              autoHideAfter: autoHideAfter,
            ),
          ),
        ),
      ],
    );
  }

  @override
  State<TimeGuide> createState() => _TimeGuideState();
}

class _TimeGuideState extends State<TimeGuide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _bubbleOpacity;
  late final Animation<double> _bubbleScale;
  bool _bubbleVisible = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _bubbleOpacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _bubbleScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _ctrl.forward();
    });
    _scheduleHide();
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    _hideTimer = Timer(widget.autoHideAfter, () {
      if (!mounted) return;
      _ctrl.reverse();
      setState(() => _bubbleVisible = false);
    });
  }

  void _toggleBubble() {
    if (_bubbleVisible) {
      _ctrl.reverse();
      _hideTimer?.cancel();
      setState(() => _bubbleVisible = false);
    } else {
      _ctrl.forward();
      setState(() => _bubbleVisible = true);
      _scheduleHide();
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 96),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_bubbleVisible)
            FadeTransition(
              opacity: _bubbleOpacity,
              child: ScaleTransition(
                scale: _bubbleScale,
                alignment: Alignment.bottomRight,
                child: _Bubble(message: widget.message, onClose: _toggleBubble),
              ),
            ),
          const SizedBox(height: 8),
          _Avatar(emoji: widget.emoji, onTap: _toggleBubble),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String message;
  final VoidCallback onClose;
  const _Bubble({required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 240),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.primaryContainer.withValues(alpha: 0.35),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  message,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onClose,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close_rounded,
                      size: 16, color: AppTheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String emoji;
  final VoidCallback onTap;
  const _Avatar({required this.emoji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7C3AED), Color(0xFF1D4ED8)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(emoji, style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}
