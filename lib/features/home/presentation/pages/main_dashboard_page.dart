import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/themed_loading.dart';
import 'package:timeexplorer/core/widgets/tap_scale.dart';
import 'package:timeexplorer/features/profile/presentation/providers/profile_provider.dart';
import 'package:timeexplorer/features/learn/presentation/daily_fact_provider.dart';
import 'package:timeexplorer/features/places/data/eras_data.dart';
import 'package:timeexplorer/features/gamification/presentation/widgets/streak_flame.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:timeexplorer/features/gamification/presentation/widgets/xp_progress_bar.dart';
import 'package:timeexplorer/features/gamification/presentation/widgets/badge_unlock_dialog.dart';
import 'package:timeexplorer/features/gamification/presentation/widgets/level_badge.dart';

class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends State<MainDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GamificationProvider>().addListener(_onGamificationChange);
    });
  }

  @override
  void dispose() {
    try {
      context.read<GamificationProvider>().removeListener(_onGamificationChange);
    } catch (_) {}
    super.dispose();
  }

  void _onGamificationChange() {
    if (!mounted) return;
    final provider = context.read<GamificationProvider>();

    if (provider.pendingLevelUp) {
      provider.clearLevelUp();
      _showLevelUpDialog(provider.progress.level);
    }

    if (provider.newlyUnlockedBadge != null) {
      final badgeId = provider.newlyUnlockedBadge!;
      final badge = provider.badges.firstWhere((b) => b.id == badgeId);
      provider.clearBadgeUnlock();
      _showBadgeDialog(badge);
    }
  }

  void _showLevelUpDialog(int level) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Center(
          child: Column(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: AppTheme.amber, size: 60),
              const SizedBox(height: 16),
              Text('LEVEL UP!', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, color: AppTheme.amber)),
            ],
          ),
        ),
        content: Text(
          'Congratulations! You have reached Level $level.',
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(color: AppTheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('AWESOME', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: AppTheme.primary)),
          ),
        ],
      ),
    );
  }

  void _showBadgeDialog(dynamic badge) {
    showDialog(
      context: context,
      builder: (context) => BadgeUnlockDialog(badge: badge),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Your Time Adventure'),
                  const SizedBox(height: 16),
                  _buildMainActionCards(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Unlock the Past'),
                  const SizedBox(height: 16),
                  _buildFeaturedEras(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Daily Discovery'),
                  const SizedBox(height: 16),
                  _buildTrendingFacts(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Begin Your Journey'),
                  const SizedBox(height: 16),
                  _buildStartExploringCard(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    return SliverAppBar(
      expandedHeight: 220,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(decoration: const BoxDecoration(gradient: AppTheme.heroGradient)),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.amberGradient,
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundImage: profile?.photoUrl != null
                                  ? NetworkImage(profile!.photoUrl!)
                                  : null,
                              backgroundColor: AppTheme.deepNavy,
                              child: profile?.photoUrl == null
                                  ? const Icon(Icons.person_rounded, color: Colors.white, size: 28)
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: context.watch<GamificationProvider>().progress.level > 0
                                ? LevelBadge(
                                    level: context.watch<GamificationProvider>().progress.level,
                                    xpProgress: context.watch<GamificationProvider>().progress.progressToNextLevel,
                                    size: 20,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _greeting(),
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        profile?.displayName ?? 'Explorer',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const StreakFlame(),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const XPProgressBar(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppTheme.onSurface,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildMainActionCards(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildActionCard(
            context,
            title: 'Explore Realms',
            subtitle: 'Journey across ancient worlds',
            icon: Icons.map_rounded,
            colors: [AppTheme.primary, AppTheme.primaryContainer],
            onTap: () => context.push('/explore'),
          ),
          const SizedBox(width: 16),
          _buildActionCard(
            context,
            title: 'Legend Chat',
            subtitle: 'Converse with historical figures',
            icon: Icons.history_edu_rounded,
            colors: [const Color(0xFFDB2777), const Color(0xFF7C3AED)],
            onTap: () => context.push('/personalities-categories'),
          ),
          const SizedBox(width: 16),
          _buildActionCard(
            context,
            title: 'Daily Quiz',
            subtitle: 'Test your knowledge limits',
            icon: Icons.auto_awesome_rounded,
            colors: [const Color(0xFF059669), const Color(0xFF10B981)],
            onTap: () => context.push('/quiz'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return TapScale(
      haptic: true,
      child: Container(
      width: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.last.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                const Spacer(),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildFeaturedEras(BuildContext context) {
    final eras = featuredEras;
    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: eras.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final era = eras[index];
          return TapScale(
            scale: 0.95,
            haptic: true,
            onTap: () => context.push('/era-details', extra: era),
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: era.outerImage.isNotEmpty 
                      ? CachedNetworkImage(
                          imageUrl: era.outerImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(color: AppTheme.surfaceLow),
                          errorWidget: (context, url, e) => Container(color: AppTheme.surfaceLow),
                        )
                      : Container(color: AppTheme.surfaceLow),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        era.eraName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStartExploringCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TapScale(
        haptic: true,
        onTap: () => context.push('/explore'),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.explore_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Exploring',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Visit places to build your timeline',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  static String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning ☀️';
    if (h < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  Widget _buildTrendingFacts(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Consumer<DailyFactProvider>(
        builder: (context, factProvider, child) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLowest,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DID YOU KNOW?',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.amber,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Icon(Icons.lightbulb_outline_rounded, color: AppTheme.amber, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                if (factProvider.isLoading)
                  const SizedBox(
                    height: 80,
                    child: Center(child: ThemedLoading(context: 'categories')),
                  )
                else
                  Text(
                    factProvider.factText,
                    style: GoogleFonts.beVietnamPro(
                      color: AppTheme.onSurface,
                      fontSize: 15,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      factProvider.factCategory,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
