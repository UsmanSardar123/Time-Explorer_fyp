import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

// ── AnimatedButton ────────────────────────────────────────────────────────────
class AnimatedButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  final bool hasGlow;
  final Color? glowColor;
  final Gradient? gradient;
  final bool haptic;

  const AnimatedButton({
    super.key,
    required this.onTap,
    required this.child,
    this.hasGlow = false,
    this.glowColor,
    this.gradient,
    this.haptic = false,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 90),
  );
  late final Animation<double> _scale = Tween(begin: 1.0, end: 0.95)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));

  bool _pressed = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = widget.glowColor ?? AppTheme.primaryElectric;
    return GestureDetector(
      onTapDown: (_) {
        _ctrl.forward();
        setState(() => _pressed = true);
        if (widget.haptic) HapticFeedback.lightImpact();
      },
      onTapUp: (_) { _ctrl.reverse(); setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () { _ctrl.reverse(); setState(() => _pressed = false); },
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            gradient: widget.gradient,
            boxShadow: (widget.hasGlow || _pressed)
                ? AppTheme.glowShadow(glowColor, intensity: _pressed ? 0.55 : 0.35, blur: 18)
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ── AnimatedCard ──────────────────────────────────────────────────────────────
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isInteractive;
  final Color? glowColor;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.isInteractive = true,
    this.glowColor,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isInteractive) return widget.child;
    final glow = widget.glowColor ?? AppTheme.primaryElectric;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap?.call(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
            border: Border.all(
              color: _pressed ? glow.withValues(alpha: 0.6) : glow.withValues(alpha: 0.12),
              width: 1.5,
            ),
            boxShadow: _pressed ? AppTheme.glowShadow(glow, intensity: 0.2, blur: 12) : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ── AnimatedIconWrapper ───────────────────────────────────────────────────────
class AnimatedIconWrapper extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback? onTap;

  const AnimatedIconWrapper({
    super.key,
    required this.icon,
    this.color = AppTheme.primaryElectric,
    this.size = 24,
    this.onTap,
  });

  @override
  State<AnimatedIconWrapper> createState() => _AnimatedIconWrapperState();
}

class _AnimatedIconWrapperState extends State<AnimatedIconWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  bool _pressed = false;

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.onTap != null
          ? (_) { setState(() => _pressed = false); widget.onTap!(); }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (_, child) => Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 0.1),
              boxShadow: AppTheme.glowShadow(
                widget.color,
                intensity: 0.12 + 0.15 * _pulse.value,
                blur: 8 + 10 * _pulse.value,
              ),
            ),
            child: Icon(widget.icon, color: widget.color, size: widget.size),
          ),
        ),
      ),
    );
  }
}
