import 'package:flutter/material.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool gamified;
  final Color? borderColor;
  final Gradient? gradient;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.gamified = false,
    this.borderColor,
    this.gradient,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.gamified) {
      return Card(
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          child: Padding(padding: widget.padding ?? const EdgeInsets.all(16), child: widget.child),
        ),
      );
    }

    final borderCol = widget.borderColor ?? AppTheme.primaryElectric;
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.onTap != null
          ? (_) { setState(() => _pressed = false); widget.onTap!(); }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 170),
          decoration: BoxDecoration(
            gradient: widget.gradient ?? AppTheme.surfaceGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
            border: Border.all(
              color: _pressed ? borderCol.withValues(alpha: 0.6) : borderCol.withValues(alpha: 0.18),
              width: 1.5,
            ),
            boxShadow: _pressed
                ? AppTheme.glowShadow(borderCol, intensity: 0.22, blur: 14)
                : null,
          ),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(16),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
