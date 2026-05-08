import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

class ChronoLoader extends StatefulWidget {
  final double size;
  final Color color;
  final String? label;

  const ChronoLoader({
    super.key,
    this.size = 48,
    this.color = AppTheme.primaryContainer,
    this.label,
  });

  @override
  State<ChronoLoader> createState() => _ChronoLoaderState();
}

class _ChronoLoaderState extends State<ChronoLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _ChronoPainter(
              progress: _ctrl.value,
              color: widget.color,
            ),
          ),
        ),
        if (widget.label != null) ...[
          const SizedBox(height: 10),
          Text(
            widget.label!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: widget.color.withValues(alpha: 0.7),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}

class _ChronoPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _ChronoPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    // Background ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = color.withValues(alpha: 0.15),
    );

    // Sweeping arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // -π/2 (start from top)
      progress * 6.283, // full circle * progress
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = color,
    );

    // Center tick dot
    canvas.drawCircle(
      center,
      3,
      Paint()..color = color.withValues(alpha: 0.6),
    );
  }

  @override
  bool shouldRepaint(_ChronoPainter old) => old.progress != progress;
}
