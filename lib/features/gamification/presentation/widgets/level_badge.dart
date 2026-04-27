import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

class LevelBadge extends StatelessWidget {
  final int level;
  final double xpProgress;
  final double size;
  final bool showBorder;
  final bool animate;

  const LevelBadge({
    super.key,
    required this.level,
    this.xpProgress = 0.0,
    this.size = 28,
    this.showBorder = true,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final ringWidth = size * 0.08;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: animate ? scale : 1.0,
          child: child,
        );
      },
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // XP Progress Ring
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: xpProgress,
                strokeWidth: ringWidth,
                backgroundColor: AppTheme.amber.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.amber),
              ),
            ),
            // Inner Circle
            Container(
              width: size - (ringWidth * 2.5),
              height: size - (ringWidth * 2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.amberGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.amber.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  level.toString(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: size * 0.42,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.onSurface,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
