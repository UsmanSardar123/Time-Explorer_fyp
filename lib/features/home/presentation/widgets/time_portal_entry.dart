import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

const List<Map<String, String>> _orbFacts = [
  {
    'title': 'Ancient Rome',
    'fact': 'At its peak, Rome had over 1 million inhabitants — a population not matched by any European city for 1,500 years after its fall.',
    'icon': '🏛️',
  },
  {
    'title': 'Great Wall of China',
    'fact': 'The Great Wall was built over many dynasties spanning 2,000 years. It stretches over 21,000 km — long enough to circle the Earth half a time.',
    'icon': '🧱',
  },
  {
    'title': 'Egyptian Mummies',
    'fact': 'Ancient Egyptians mummified not just humans but also cats, crocodiles, and ibises — often as offerings to the gods.',
    'icon': '⚱️',
  },
  {
    'title': 'Viking Navigation',
    'fact': 'Vikings may have used crystals called "sunstones" to navigate by polarized sunlight even on cloudy days — centuries before the magnetic compass reached Europe.',
    'icon': '🧭',
  },
  {
    'title': 'Cleopatra\'s Era',
    'fact': 'Cleopatra VII lived closer in time to the Moon landing (1969) than to the construction of the Great Pyramid of Giza (2560 BCE).',
    'icon': '👑',
  },
  {
    'title': 'Silk Road',
    'fact': 'The Silk Road wasn\'t just a trade route for silk — it carried ideas, religions, diseases, and technologies between East and West for over 1,500 years.',
    'icon': '🗺️',
  },
  {
    'title': 'Medieval Time',
    'fact': 'Medieval people did not believe the Earth was flat. Most educated Europeans knew it was round since at least the time of Aristotle (4th century BCE).',
    'icon': '🌍',
  },
  {
    'title': 'The Mongol Empire',
    'fact': 'At its height, the Mongol Empire was the largest contiguous land empire in history, covering over 24 million square kilometers.',
    'icon': '🏹',
  },
  {
    'title': 'Ancient Greece',
    'fact': 'The ancient Olympics began in 776 BCE as a religious festival honoring Zeus. Only men who spoke Greek could compete — women were forbidden even as spectators.',
    'icon': '🏺',
  },
  {
    'title': 'Maya Civilization',
    'fact': 'The Maya had one of the most accurate calendar systems in the ancient world, predicting solar eclipses and planetary cycles with remarkable precision.',
    'icon': '📅',
  },
];

class TimePortalEntry extends StatefulWidget {
  final VoidCallback onEnter;
  const TimePortalEntry({super.key, required this.onEnter});

  @override
  State<TimePortalEntry> createState() => _TimePortalEntryState();
}

class _TimePortalEntryState extends State<TimePortalEntry>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this, duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  late final AnimationController _orbitCtrl = AnimationController(
    vsync: this, duration: const Duration(seconds: 5),
  )..repeat();

  late final AnimationController _entryCtrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 1400),
  )..forward();

  late final AnimationController _orbTapCtrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 300),
  );

  final _rng = math.Random();

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _orbitCtrl.dispose();
    _entryCtrl.dispose();
    _orbTapCtrl.dispose();
    super.dispose();
  }

  void _onOrbTap() {
    HapticFeedback.mediumImpact();
    _orbTapCtrl.forward(from: 0).then((_) => _orbTapCtrl.reverse());
    final fact = _orbFacts[_rng.nextInt(_orbFacts.length)];
    _showOrbSheet(fact);
  }

  void _showOrbSheet(Map<String, String> fact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _OrbInsightSheet(fact: fact),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _SpaceBackground(),
          AnimatedBuilder(
            animation: Listenable.merge([_pulseCtrl, _orbitCtrl, _orbTapCtrl]),
            builder: (_, __) => CustomPaint(
              painter: _PortalPainter(
                pulse: _pulseCtrl.value,
                orbit: _orbitCtrl.value,
                tapScale: 1.0 + _orbTapCtrl.value * 0.2,
              ),
            ),
          ),
          // Orb tap target — centered at 40% height
          Align(
            alignment: const Alignment(0, -0.22),
            child: GestureDetector(
              onTap: _onOrbTap,
              child: Container(
                width: 130,
                height: 130,
                color: Colors.transparent,
              ),
            ),
          ),
          FadeTransition(
            opacity: CurvedAnimation(parent: _entryCtrl, curve: Curves.easeIn),
            child: _PortalContent(onEnter: widget.onEnter),
          ),
        ],
      ),
    );
  }
}

class _SpaceBackground extends StatelessWidget {
  const _SpaceBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.4,
          colors: [Color(0xFF1A1250), Color(0xFF0A0820), Color(0xFF080818)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

class _PortalPainter extends CustomPainter {
  final double pulse;
  final double orbit;
  final double tapScale;

  const _PortalPainter({
    required this.pulse,
    required this.orbit,
    this.tapScale = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.40);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(tapScale);
    canvas.translate(-center.dx, -center.dy);
    _drawGlowOrb(canvas, center);
    _drawRings(canvas, center);
    canvas.restore();
    _drawParticles(canvas, center);
  }

  void _drawGlowOrb(Canvas canvas, Offset center) {
    canvas.drawCircle(
      center,
      52 + pulse * 10,
      Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFF818CF8).withValues(alpha: 0.9),
          const Color(0xFF4F46E5).withValues(alpha: 0.5),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: center, radius: 90)),
    );
  }

  void _drawRings(Canvas canvas, Offset center) {
    for (int i = 0; i < 4; i++) {
      final radius = 64.0 + i * 34 + pulse * 16;
      final opacity = (1 - i * 0.2) * (0.25 + (1 - pulse) * 0.35);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5 - i * 0.2
          ..color = const Color(0xFF818CF8).withValues(alpha: opacity),
      );
    }
  }

  void _drawParticles(Canvas canvas, Offset center) {
    for (int i = 0; i < 18; i++) {
      final angle = orbit * math.pi * 2 + (i * math.pi / 9);
      final radius = 96.0 + (i % 4) * 28;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle * 0.75);
      canvas.drawCircle(
        Offset(x, y),
        1.4 + (i % 3) * 0.7,
        Paint()
          ..color = const Color(0xFFC4B5FD)
              .withValues(alpha: 0.25 + (i % 4) * 0.14),
      );
    }
  }

  @override
  bool shouldRepaint(_PortalPainter old) =>
      old.pulse != pulse || old.orbit != orbit || old.tapScale != tapScale;
}

class _PortalContent extends StatelessWidget {
  final VoidCallback onEnter;
  const _PortalContent({required this.onEnter});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(flex: 6),
          Text(
            'TIME EXPLORER',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Your journey through history awaits',
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: Colors.white54,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the orb to discover a history insight',
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              color: Colors.white30,
              letterSpacing: 0.3,
            ),
          ),
          const Spacer(flex: 2),
          _EnterTimelineButton(onTap: onEnter),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class _EnterTimelineButton extends StatelessWidget {
  final VoidCallback onTap;
  const _EnterTimelineButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 18),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryContainer.withValues(alpha: 0.55),
              blurRadius: 32,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Text(
          'Enter Timeline  →',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ── Orb insight bottom sheet ──────────────────────────────────────────────────

class _OrbInsightSheet extends StatelessWidget {
  final Map<String, String> fact;
  const _OrbInsightSheet({required this.fact});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0D2A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF4F46E5).withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF818CF8).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    fact['icon']!,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TIMELINE INSIGHT',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF818CF8),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fact['title']!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4F46E5).withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              fact['fact']!,
              style: GoogleFonts.beVietnamPro(
                fontSize: 15,
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.7,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF818CF8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Continue Journey',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
