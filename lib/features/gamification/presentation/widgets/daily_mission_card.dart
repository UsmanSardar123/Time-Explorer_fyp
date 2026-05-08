import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/confetti_burst.dart';
import 'package:timeexplorer/features/gamification/domain/entities/daily_mission.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';

class DailyMissionCard extends StatefulWidget {
  const DailyMissionCard({super.key});

  @override
  State<DailyMissionCard> createState() => _DailyMissionCardState();
}

class _DailyMissionCardState extends State<DailyMissionCard> {
  bool _playConfetti = false;

  Future<void> _onClaim(GamificationProvider gam) async {
    final awarded = await gam.claimDailyMissionReward();
    if (!mounted || !awarded) return;
    setState(() => _playConfetti = true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamificationProvider>(
      builder: (context, gam, _) {
        final mission = gam.dailyMission;
        return Stack(
          children: [
            _Card(
              mission: mission,
              onClaim: mission.completed && !mission.claimed
                  ? () => _onClaim(gam)
                  : null,
            ),
            Positioned.fill(
              child: ConfettiBurst(
                play: _playConfetti,
                seedColor: AppTheme.primaryContainer,
                onComplete: () {
                  if (mounted) setState(() => _playConfetti = false);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  final DailyMission mission;
  final VoidCallback? onClaim;

  const _Card({required this.mission, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    final accent = AppTheme.primaryContainer;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.16),
            accent.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.30), width: 1.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(emoji: mission.emoji, accent: accent, claimed: mission.claimed),
          const SizedBox(height: 12),
          Text(
            mission.description,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          _ProgressBar(
            ratio: mission.ratio,
            label: '${mission.progress} / ${mission.target}',
            accent: accent,
          ),
          const SizedBox(height: 14),
          _ActionRow(
            mission: mission,
            accent: accent,
            onClaim: onClaim,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String emoji;
  final Color accent;
  final bool claimed;
  const _Header({required this.emoji, required this.accent, required this.claimed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.20),
            shape: BoxShape.circle,
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: 10),
        Text(
          'Daily Mission',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.onSurface,
          ),
        ),
        const Spacer(),
        if (claimed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A).withValues(alpha: 0.15),
              border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'CLAIMED',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF166534),
                letterSpacing: 0.8,
              ),
            ),
          ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double ratio;
  final String label;
  final Color accent;

  const _ProgressBar({
    required this.ratio,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 10,
            backgroundColor: accent.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final DailyMission mission;
  final Color accent;
  final VoidCallback? onClaim;

  const _ActionRow({required this.mission, required this.accent, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt_rounded, size: 14, color: accent),
              const SizedBox(width: 4),
              Text(
                '+${mission.rewardXp} XP',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (onClaim != null)
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: onClaim,
              icon: const Icon(Icons.celebration_rounded, size: 22),
              label: Text(
                'Claim',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                padding: const EdgeInsets.symmetric(horizontal: 22),
              ),
            ),
          )
        else if (mission.claimed)
          Text(
            'Come back tomorrow!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfaceVariant,
            ),
          )
        else
          Text(
            'Keep going!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
      ],
    );
  }
}
