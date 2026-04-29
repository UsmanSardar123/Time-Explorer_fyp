import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/fade_slide_in.dart';
import 'package:timeexplorer/core/widgets/tap_scale.dart';
import '../../domain/entities/quiz_topic.dart';

class QuizDashboardPage extends StatelessWidget {
  const QuizDashboardPage({super.key});

  // ── Design Tokens ─────────────────────────────────────────────────────────
  static const _primary = AppTheme.primaryContainer;
  static const _bg = AppTheme.background;
  static const _surfaceLow = AppTheme.surfaceLow;
  static const _surfaceCard = AppTheme.surface;
  static const _textDark = AppTheme.onSurface;
  static const _textMuted = AppTheme.onSurfaceVariant;

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
      backgroundColor: _bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Header
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
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                   'Master knowledge from different timelines',
                   style: GoogleFonts.beVietnamPro(fontSize: 14, color: _textMuted),
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
        color: _textDark,
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
            'Journey through questions that shaped the world',
            style: GoogleFonts.beVietnamPro(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEpochHeader(EpochCategory epoch) {
    final name = epoch.toString().split('.').last.toUpperCase();
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Container(height: 1, width: 24, color: _primary.withValues(alpha: 0.3)),
          const SizedBox(width: 12),
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: _primary,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider(color: _surfaceCard)),
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
              color: _textDark.withValues(alpha: 0.04),
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
              color: _surfaceLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.bolt_rounded, color: _primary, size: 24),
          ),
          title: Text(
            topic.title,
            style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            '10 Questions • ${topic.difficultyLevel.label}',
            style: GoogleFonts.beVietnamPro(fontSize: 13, color: _textMuted),
          ),
          trailing: const Icon(Icons.play_circle_fill_rounded, color: _primary, size: 32),
        ),
      ),
    );
  }
}
