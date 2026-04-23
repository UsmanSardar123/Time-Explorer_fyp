import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TapScale extends StatefulWidget {
  final Widget child;
  final double scale;
  final VoidCallback? onTap;
  final bool haptic;

  const TapScale({
    super.key,
    required this.child,
    this.scale = 0.95,
    this.onTap,
    this.haptic = false,
  });

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() => _pressed = true);
        if (widget.haptic) HapticFeedback.lightImpact();
      },
      onPointerUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
