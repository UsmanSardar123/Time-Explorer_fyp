import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/historical_event.dart';

/// Returns the minimum level required to unlock [event], or 0 if free.
int requiredLevel(HistoricalEvent event) {
  if (event.importanceLevel >= 5) return 5;
  if (event.importanceLevel >= 4) return 3;
  return 0;
}

bool isEventLocked(HistoricalEvent event, int userLevel) =>
    userLevel < requiredLevel(event);

/// Full-page lock screen shown when the user lacks the required level.
class MemoryLockScreen extends StatelessWidget {
  final HistoricalEvent event;
  final int required;
  final String? hint;

  const MemoryLockScreen({
    super.key,
    required this.event,
    required this.required,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final accent = event.category.color;
    return Scaffold(
      backgroundColor: const Color(0xFF0C0B1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.15),
                  border: Border.all(color: accent.withValues(alpha: 0.4), width: 2),
                ),
                child: Icon(Icons.lock_rounded, color: accent, size: 48),
              ),
              const SizedBox(height: 28),
              Text(
                'Memory Locked',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                hint?.isNotEmpty == true
                    ? hint!
                    : 'This historical memory unlocks at Epoch $required.\nKeep exploring to advance your timeline.',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  color: Colors.white54,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, color: accent, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Required: Epoch $required',
                      style: GoogleFonts.plusJakartaSans(
                        color: accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  foregroundColor: Colors.white70,
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small lock badge overlaid on event cards.
class LockBadge extends StatelessWidget {
  final int requiredLvl;
  const LockBadge({super.key, required this.requiredLvl});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_rounded, color: Colors.white70, size: 12),
            const SizedBox(width: 4),
            Text(
              'Ep.$requiredLvl',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: Colors.white70,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
