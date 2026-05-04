import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/fade_slide_in.dart';
import 'package:timeexplorer/core/widgets/tap_scale.dart';
import '../../domain/entities/quiz_topic.dart';

class QuizDashboardPage extends StatefulWidget {
  const QuizDashboardPage({super.key});

  // ── Design Tokens ─────────────────────────────────────────────────────────
  static const primary = AppTheme.primaryContainer;
  static const background = AppTheme.background;
  static const surfaceLow = AppTheme.surfaceLow;
  static const surfaceCard = AppTheme.surface;
  static const textDark = AppTheme.onSurface;
  static const textMuted = AppTheme.onSurfaceVariant;

  @override
  State<QuizDashboardPage> createState() => _QuizDashboardPageState();
}

class _QuizDashboardPageState extends State<QuizDashboardPage> {
  DifficultyLevel? _selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    final grouped = <EpochCategory, List<QuizTopic>>{};
    for (final topic in allTopics) {
      grouped.putIfAbsent(topic.epochCategory, () => []).add(topic);
    }
    final orderedEpochs = [
      EpochCategory.ancient,
      EpochCategory.discovery,
      EpochCategory.modern,
      EpochCategory.global,
    ];

    return Scaffold(
      backgroundColor: QuizDashboardPage.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Header with Difficulty Selection
          SliverToBoxAdapter(child: _buildHeader()),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 32),
                Text(
                  'Choose Your Era',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: QuizDashboardPage.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                   'Master knowledge from different timelines',
                   style: GoogleFonts.beVietnamPro(fontSize: 14, color: QuizDashboardPage.textMuted),
                ),
                
                const SizedBox(height: 24),
                
                ..._buildAnimatedTopics(context, grouped, orderedEpochs),
                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 70, 24, 40),
      decoration: const BoxDecoration(
        color: QuizDashboardPage.textDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(44),
          bottomRight: Radius.circular(44),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timeline Challenge',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a difficulty to start your daily mission',
            style: GoogleFonts.beVietnamPro(color: Colors.white60, fontSize: 14),
          ),
          const SizedBox(height: 32),
          
          // Difficulty Selector
          _buildDifficultySelector(),
          
          const SizedBox(height: 24),
          
          // Start Button
          _buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Row(
      children: [
        _buildDifficultyCard(DifficultyLevel.easy, 'Beginner', Colors.greenAccent),
        const SizedBox(width: 12),
        _buildDifficultyCard(DifficultyLevel.medium, 'Enthusiast', Colors.amberAccent),
        const SizedBox(width: 12),
        _buildDifficultyCard(DifficultyLevel.hard, 'Expert', Colors.redAccent),
      ],
    );
  }

  Widget _buildDifficultyCard(DifficultyLevel level, String label, Color color) {
    final isSelected = _selectedDifficulty == level;
    
    return Expanded(
      child: TapScale(
        onTap: () => setState(() => _selectedDifficulty = level),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : Colors.white24,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? color : Colors.white38,
                size: 20,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: isSelected ? color : Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    final isEnabled = _selectedDifficulty != null;
    
    return TapScale(
      onTap: isEnabled ? () {
        context.push(
          '/quiz-play', 
          extra: QuizTopic(
            title: 'Daily History Challenge',
            description: 'A 10-question challenge at the ${_selectedDifficulty!.label} level.',
            difficultyLevel: _selectedDifficulty!,
            epochCategory: EpochCategory.global,
            imageUrl: '', 
            icon: Icons.history_edu,
            color: QuizDashboardPage.primary,
          ),
        );
      } : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isEnabled ? QuizDashboardPage.primary : Colors.white10,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isEnabled ? [
            BoxShadow(
              color: QuizDashboardPage.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ] : null,
        ),
        child: Center(
          child: Text(
            'START DAILY QUIZ',
            style: GoogleFonts.plusJakartaSans(
              color: isEnabled ? QuizDashboardPage.textDark : Colors.white24,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEpochHeader(EpochCategory epoch) {
    final name = epoch.toString().split('.').last.toUpperCase();
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Container(height: 1, width: 24, color: QuizDashboardPage.primary.withValues(alpha: 0.3)),
          const SizedBox(width: 12),
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: QuizDashboardPage.primary,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider(color: QuizDashboardPage.surfaceCard)),
        ],
      ),
    );
  }

  List<Widget> _buildAnimatedTopics(
    BuildContext context,
    Map<EpochCategory, List<QuizTopic>> grouped,
    List<EpochCategory> orderedEpochs,
  ) {
    var i = 0;
    final widgets = <Widget>[];
    for (final epoch in orderedEpochs.where(grouped.containsKey)) {
      widgets.add(FadeSlideIn(index: i++, child: _buildEpochHeader(epoch)));
      for (final topic in grouped[epoch]!) {
        widgets.add(FadeSlideIn(index: i++, child: _buildTopicTile(context, topic)));
      }
      widgets.add(const SizedBox(height: 16));
    }
    return widgets;
  }

  Widget _buildTopicTile(BuildContext context, QuizTopic topic) {
    return TapScale(
      haptic: true,
      onTap: () => context.push('/quiz-play', extra: topic),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: QuizDashboardPage.textDark.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          onTap: null,
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: QuizDashboardPage.surfaceLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.bolt_rounded, color: QuizDashboardPage.primary, size: 24),
          ),
          title: Text(
            topic.title,
            style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            '10 Questions • ${topic.difficultyLevel.label}',
            style: GoogleFonts.beVietnamPro(fontSize: 13, color: QuizDashboardPage.textMuted),
          ),
          trailing: const Icon(Icons.play_circle_fill_rounded, color: QuizDashboardPage.primary, size: 32),
        ),
      ),
    );
  }
}
