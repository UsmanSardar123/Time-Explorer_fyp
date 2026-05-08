import 'dart:math';
import 'package:flutter/material.dart';

/// One-shot confetti burst rendered with a CustomPainter (no packages).
/// Place inside an `IgnorePointer` so it never blocks taps.
///
/// `play` toggles the animation: setting it from `false → true` triggers
/// a single play. Reset to `false` after `onComplete`.
class ConfettiBurst extends StatefulWidget {
  final bool play;
  final Color seedColor;
  final int particleCount;
  final Duration duration;
  final VoidCallback? onComplete;

  const ConfettiBurst({
    super.key,
    required this.play,
    this.seedColor = const Color(0xFF7C3AED),
    this.particleCount = 28,
    this.duration = const Duration(milliseconds: 1400),
    this.onComplete,
  });

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  List<_Particle> _particles = const [];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onComplete?.call();
    });
    if (widget.play) _start();
  }

  @override
  void didUpdateWidget(ConfettiBurst old) {
    super.didUpdateWidget(old);
    if (widget.play && !old.play) _start();
  }

  void _start() {
    _particles = _generate(widget.particleCount, widget.seedColor);
    _ctrl
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return CustomPaint(
            painter: _ConfettiPainter(
              particles: _particles,
              t: _ctrl.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  static List<_Particle> _generate(int count, Color seed) {
    final rng = Random();
    final palette = <Color>[
      seed,
      const Color(0xFFF59E0B), // amber
      const Color(0xFF16A34A), // green
      const Color(0xFFDC2626), // red
      const Color(0xFF1D4ED8), // blue
      const Color(0xFFEC4899), // pink
    ];
    return List.generate(count, (_) {
      final angle = (-pi / 2) + (rng.nextDouble() - 0.5) * 1.4;
      final speed = 220 + rng.nextDouble() * 220;
      return _Particle(
        color: palette[rng.nextInt(palette.length)],
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        rotation: rng.nextDouble() * pi,
        rotationSpeed: (rng.nextDouble() - 0.5) * 8,
        size: 4 + rng.nextDouble() * 6,
        delay: rng.nextDouble() * 0.15,
      );
    });
  }
}

class _Particle {
  final Color color;
  final double vx;
  final double vy;
  final double rotation;
  final double rotationSpeed;
  final double size;
  final double delay;

  const _Particle({
    required this.color,
    required this.vx,
    required this.vy,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
    required this.delay,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;

  _ConfettiPainter({required this.particles, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    if (particles.isEmpty) return;
    final origin = Offset(size.width / 2, size.height * 0.6);
    const gravity = 720.0;

    for (final p in particles) {
      final localT = ((t - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (localT <= 0) continue;
      final dt = localT * 1.2;

      final dx = p.vx * dt;
      final dy = p.vy * dt + 0.5 * gravity * dt * dt;
      final pos = origin + Offset(dx, dy);
      if (pos.dy > size.height + 20) continue;

      final fade = 1 - localT;
      final paint = Paint()
        ..color = p.color.withValues(alpha: fade.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(p.rotation + p.rotationSpeed * dt);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.45),
          const Radius.circular(1.4),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.t != t || old.particles != particles;
}
