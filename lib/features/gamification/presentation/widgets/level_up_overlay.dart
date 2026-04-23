import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import '../providers/gamification_provider.dart';

/// Wrap any Scaffold body with this widget to get the level-up animation.
/// Usage: LevelUpOverlay(child: YourWidget())
class LevelUpOverlay extends StatelessWidget {
  final Widget child;
  const LevelUpOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<GamificationProvider>(
      builder: (context, gam, _) => Stack(
        children: [
          child,
          if (gam.pendingLevelUp)
            _LevelUpAnimation(
              level: gam.progress.level,
              rank:  gam.progress.rankLabel,
              onDone: gam.clearLevelUp,
            ),
        ],
      ),
    );
  }
}

// ── Private animation widget ──────────────────────────────────────────────────

class _LevelUpAnimation extends StatefulWidget {
  final int    level;
  final String rank;
  final VoidCallback onDone;

  const _LevelUpAnimation({
    required this.level,
    required this.rank,
    required this.onDone,
  });

  @override
  State<_LevelUpAnimation> createState() => _LevelUpAnimationState();
}

class _LevelUpAnimationState extends State<_LevelUpAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _opacity;
  late final Animation<double>   _scale;

  static const _accent = AppTheme.primaryContainer;
  static const _glow   = Color(0xFF818CF8);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0),           weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_ctrl);

    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.4, curve: Curves.elasticOut)),
    );

    _ctrl.forward().then((_) {
      if (mounted) widget.onDone();
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
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Container(
          color: Colors.black.withValues(alpha: 0.55),
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
              decoration: BoxDecoration(
                color: const Color(0xFF001A4D),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _accent, width: 2),
                boxShadow: [
                  BoxShadow(color: _glow.withValues(alpha: 0.45), blurRadius: 40, spreadRadius: 4),
                  BoxShadow(color: _glow.withValues(alpha: 0.20), blurRadius: 80, spreadRadius: 16),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    'LEVEL UP!',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: _accent,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Level ${widget.level}  ·  ${widget.rank}',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
