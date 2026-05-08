import 'package:flutter/material.dart';

class ShimmerBox extends StatefulWidget {
  final double? width;
  final double? height;
  final double radius;

  const ShimmerBox({super.key, this.width, this.height, this.radius = 12});

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Using theme-adaptive colors for a more integrated look
    final baseColor = isDark ? const Color(0xFF1E1D2D) : const Color(0xFFEBE9F5);
    final highlightColor = isDark ? const Color(0xFF2B2A3D) : const Color(0xFFF4F3FB);

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        final v = _ctrl.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                (v - 0.4).clamp(0.0, 1.0),
                v.clamp(0.0, 1.0),
                (v + 0.4).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
