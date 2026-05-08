import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LockedCardOverlay extends StatelessWidget {
  final Widget child;
  final int requiredLevel;
  final Color accent;

  const LockedCardOverlay({
    super.key,
    required this.child,
    required this.requiredLevel,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.33, 0.33, 0.33, 0, 0,
            0.33, 0.33, 0.33, 0, 0,
            0.33, 0.33, 0.33, 0, 0,
            0,    0,    0,    1, 0,
          ]),
          child: child,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.40),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: _LockBadge(requiredLevel: requiredLevel, accent: accent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LockBadge extends StatelessWidget {
  final int requiredLevel;
  final Color accent;
  const _LockBadge({required this.requiredLevel, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.65),
            border: Border.all(color: accent.withValues(alpha: 0.6), width: 2.4),
          ),
          child: const Icon(Icons.lock_rounded, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            border: Border.all(color: accent.withValues(alpha: 0.55)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Level up to unlock! 🚀',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }
}
