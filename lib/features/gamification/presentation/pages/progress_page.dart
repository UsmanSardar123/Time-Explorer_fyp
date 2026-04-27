import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/widgets/fade_slide_in.dart';
import 'package:timeexplorer/core/widgets/xp_bar.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with SingleTickerProviderStateMixin {
  static const _primary     = AppTheme.primaryContainer;
  static const _primaryLight = Color(0xFF818CF8); // Indigo 400
  static const _bg          = AppTheme.background;
  static const _surfaceLow  = AppTheme.surfaceLow;
  static const _textDark    = AppTheme.onSurface;
  static const _textMuted   = AppTheme.onSurfaceVariant;

  late final AnimationController _ringCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );
  late Animation<double> _ringAnim = const AlwaysStoppedAnimation(0.0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<GamificationProvider>().progress;
      _ringAnim = Tween<double>(begin: 0.0, end: p.xpProgress)
          .animate(CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOutCubic));
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _ringCtrl.forward();
      });
    });
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GamificationProvider>().progress;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Your Journey',
            style: GoogleFonts.plusJakartaSans(
                color: _textDark, fontWeight: FontWeight.w800)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            FadeSlideIn(index: 0, child: _buildLevelCard(p)),
            const SizedBox(height: 24),
            FadeSlideIn(index: 1, child: _buildXpBarSection(p)),
            const SizedBox(height: 32),
            FadeSlideIn(index: 2, child: _buildStatsGrid(p)),
            const SizedBox(height: 32),
            FadeSlideIn(index: 3, child: _buildMilestones(p)),
            const SizedBox(height: 32),
            FadeSlideIn(index: 4, child: _buildBadgeGallery(p)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(dynamic p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _surfaceLow,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _ringAnim,
            builder: (_, child) => Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CircularProgressIndicator(
                    value: _ringAnim.value,
                    strokeWidth: 10,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(_primary),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${p.level}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32, fontWeight: FontWeight.w900, color: _primary,
                        )),
                    Text('LVL',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10, fontWeight: FontWeight.w700,
                          color: _textMuted, letterSpacing: 1.5,
                        )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Level ${p.level}',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 24, fontWeight: FontWeight.w800, color: _textDark)),
          const SizedBox(height: 4),
          Text(p.rankLabel,
              style: GoogleFonts.beVietnamPro(
                  fontSize: 14, color: _textMuted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildXpBarSection(dynamic p) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _textDark.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: XpBar(
        progress: p.xpProgress,
        totalXP: p.totalXP,
        xpToNext: p.xpToNextLevel,
        color: _primary,
        animDelayMs: 600,
      ),
    );
  }

  Widget _buildStatsGrid(dynamic p) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildStatCard(
              'Total XP', '${p.totalXP}', Icons.history_edu_rounded),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
              'Streak', '${p.streak} Days', Icons.whatshot_rounded),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _textDark.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _primary, size: 20),
          const SizedBox(height: 12),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.beVietnamPro(fontSize: 12, color: _textMuted)),
        ],
      ),
    );
  }

  Widget _buildMilestones(dynamic p) {
    final milestones = [
      (title: 'Archeologist',     subtitle: 'Reached Level 5',  required: 5),
      (title: 'Chronos-Explorer', subtitle: 'Reached Level 10', required: 10),
      (title: 'Master of Ages',   subtitle: 'Reached Level 25', required: 25),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Journey Milestones',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        ...milestones.map((m) {
          final done = p.level >= m.required;
          return _buildMilestoneItem(m.title, m.subtitle, done);
        }),
      ],
    );
  }

  Widget _buildMilestoneItem(String title, String subtitle, bool completed) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? _primary : AppTheme.outlineVariant,
                boxShadow: completed
                    ? [BoxShadow(
                        color: _primaryLight.withValues(alpha: 0.4),
                        blurRadius: 8, spreadRadius: 1,
                      )]
                    : null,
              ),
            ),
            Container(width: 2, height: 40, color: AppTheme.outlineVariant),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: completed ? _textDark : _textMuted,
                  )),
              Text(subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 12, color: _textMuted)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeGallery(dynamic p) {
    final badges = [
      (icon: Icons.military_tech_rounded, label: 'Pioneer', unlocked: true),
      (icon: Icons.explore_rounded,       label: 'Explorer', unlocked: p.level >= 5),
      (icon: Icons.auto_awesome_rounded,  label: 'Scholar',  unlocked: p.level >= 10),
      (icon: Icons.workspace_premium_rounded, label: 'Master', unlocked: p.level >= 25),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Badges',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: badges.length,
            itemBuilder: (_, i) {
              final b = badges[i];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 80,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: b.unlocked ? _surfaceLow : AppTheme.surfaceHigh,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: b.unlocked
                      ? [BoxShadow(
                          color: _primaryLight.withValues(alpha: 0.2),
                          blurRadius: 12, spreadRadius: 1,
                        )]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      b.icon,
                      color: b.unlocked ? _primary : AppTheme.outlineVariant,
                      size: 36,
                    ),
                    const SizedBox(height: 4),
                    Text(b.label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: b.unlocked ? _textMuted : AppTheme.outlineVariant,
                        )),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
