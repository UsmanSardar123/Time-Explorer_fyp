import 'package:flutter/material.dart';

class UnlockRevealAnimation extends StatefulWidget {
  final Widget child;
  final Color accent;
  final VoidCallback onShown;

  const UnlockRevealAnimation({
    super.key,
    required this.child,
    required this.accent,
    required this.onShown,
  });

  @override
  State<UnlockRevealAnimation> createState() => _UnlockRevealAnimationState();
}

class _UnlockRevealAnimationState extends State<UnlockRevealAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _glow = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onShown();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Stack(
            children: [
              child!,
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: _glow.value,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: widget.accent
                                .withValues(alpha: 0.6 * _glow.value),
                            blurRadius: 28,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}
