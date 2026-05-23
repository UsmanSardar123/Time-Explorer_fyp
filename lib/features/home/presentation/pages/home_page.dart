import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/gamified_components.dart';
import 'package:timeexplorer/features/gamification/domain/entities/user_progress.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:timeexplorer/features/profile/presentation/providers/profile_provider.dart';
import 'package:timeexplorer/features/learn/presentation/daily_fact_provider.dart';
import 'package:timeexplorer/features/places/data/eras_data.dart';
import 'package:timeexplorer/features/gamification/presentation/widgets/level_up_overlay.dart';
import 'package:timeexplorer/features/gamification/presentation/widgets/daily_mission_card.dart';
import 'package:timeexplorer/core/widgets/time_guide.dart';
import 'package:timeexplorer/core/widgets/dynamic_place_image.dart';
import 'package:timeexplorer/core/widgets/xp_bar.dart';
import 'package:timeexplorer/core/widgets/chrono_loader.dart';

import 'package:timeexplorer/features/explore/presentation/pages/explore_page.dart';
import 'package:timeexplorer/features/personalities/presentation/pages/categories_page.dart';
import 'package:timeexplorer/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:timeexplorer/features/gamification/presentation/pages/progress_page.dart';
import 'package:timeexplorer/features/profile/presentation/pages/profile_page.dart';
import 'package:timeexplorer/features/home/presentation/widgets/time_portal_entry.dart';
import 'package:timeexplorer/features/notifications/presentation/providers/notification_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _portalEntered = false;

  late AnimationController _navController;
  late AnimationController _navRevealCtrl;

  @override
  void initState() {
    super.initState();
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _navRevealCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _navController.dispose();
    _navRevealCtrl.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    _navController.forward(from: 0);
  }

  void _onPortalEntered() {
    setState(() => _portalEntered = true);
    _navRevealCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LevelUpOverlay(
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: _buildBody(),
        bottomNavigationBar: _portalEntered
            ? FadeTransition(
                opacity: _navRevealCtrl,
                child: _buildBottomNavBar(),
              )
            : null,
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        _TimePortalHome(onEntered: _onPortalEntered),
        const ExplorePage(),
        const CategoriesPage(),
        const ProgressPage(),
        const ProfilePage(),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return SafeArea(
      top: false,
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLowest,
          border: const Border(top: BorderSide(color: AppTheme.outlineVariant, width: 1)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_rounded, 'Home'),
            _buildNavItem(1, Icons.explore_rounded, 'Explore'),
            _buildNavItem(2, Icons.forum_rounded, 'Chat'),
            _buildNavItem(3, Icons.military_tech_rounded, 'Journey'),
            _buildNavItem(4, Icons.person_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return AnimatedButton(
      onTap: () => _onTabTapped(index),
      haptic: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minWidth: 64, minHeight: 64),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryContainer.withValues(alpha: 0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryContainer : AppTheme.onSurfaceVariant,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppTheme.primaryContainer : AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Portal → Dashboard gate ───────────────────────────────────────────────────

class _TimePortalHome extends StatefulWidget {
  final VoidCallback onEntered;
  const _TimePortalHome({required this.onEntered});
  @override
  State<_TimePortalHome> createState() => _TimePortalHomeState();
}

class _TimePortalHomeState extends State<_TimePortalHome> {
  bool _entered = false;

  void _handleEnter() {
    setState(() => _entered = true);
    widget.onEntered();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeIn),
        child: child,
      ),
      child: _entered
          ? const _TimeExplorerDashboard(key: ValueKey('dashboard'))
          : TimePortalEntry(
              key: const ValueKey('portal'),
              onEnter: _handleEnter,
            ),
    );
  }
}

// ── Main Dashboard ────────────────────────────────────────────────────────────

class _TimeExplorerDashboard extends StatefulWidget {
  const _TimeExplorerDashboard({super.key});

  @override
  State<_TimeExplorerDashboard> createState() => _TimeExplorerDashboardState();
}

class _TimeExplorerDashboardState extends State<_TimeExplorerDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GamificationProvider>().recordFactViewed();
        _precacheEraImages();
        _initNotifications();
      }
    });
  }

  void _initNotifications() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) context.read<NotificationProvider>().init(uid);
  }

  void _precacheEraImages() {
    for (final era in featuredEras) {
      if (era.outerImage.isNotEmpty) {
        precacheImage(CachedNetworkImageProvider(era.outerImage), context);
      }
      if (era.innerImage.isNotEmpty) {
        precacheImage(CachedNetworkImageProvider(era.innerImage), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final gamProvider = context.watch<GamificationProvider>();
    final progress = gamProvider.progress;
    final factProvider = context.watch<DailyFactProvider>();

    return Stack(
      children: [
        Positioned.fill(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: _buildSlivers(context, profile, gamProvider, progress, factProvider),
          ),
        ),
        const Align(
          alignment: Alignment.bottomRight,
          child: TimeGuide(message: "Let's explore! Tap a card to begin."),
        ),
      ],
    );
  }

  List<Widget> _buildSlivers(
    BuildContext context,
    dynamic profile,
    dynamic gamProvider,
    dynamic progress,
    dynamic factProvider,
  ) {
    return [
        SliverAppBar(
          backgroundColor: AppTheme.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          pinned: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good day, ${profile?.displayName.split(' ').first ?? "Explorer"} 👋',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          actions: [
            _NotificationIconButton(),
          ],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                _buildSearchBar(context),
                const SizedBox(height: 20),
                _buildHeroCard(context),
                const SizedBox(height: 28),
                _buildXPSection(gamProvider, progress),
                const SizedBox(height: 24),
                const DailyMissionCard(),
                const SizedBox(height: 28),
                _buildSectionHeader('Featured Eras'),
                const SizedBox(height: 14),
                _buildErasCarousel(context),
                const SizedBox(height: 28),
                _buildQuickActions(context),
                const SizedBox(height: 28),
                _buildDailyFactCard(factProvider),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
    ];
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/search'),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outlineVariant, width: 1.5),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search_rounded, color: AppTheme.onSurfaceVariant, size: 20),
            const SizedBox(width: 10),
            Text(
              'Search places, eras, figures…',
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: AppTheme.outlineVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return AnimatedCard(
      onTap: () => context.push('/era-details', extra: featuredEras.first),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: AppTheme.heroGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.25),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'FEATURED',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore Ancient\nCivilizations',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Start exploring',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
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

  Widget _buildXPSection(GamificationProvider gamProvider, UserProgress progress) {
    if (gamProvider.isInitializing) {
      return Container(
        height: 96,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outlineVariant, width: 1),
        ),
        child: const Center(
          child: ChronoLoader(size: 32, label: 'Loading timeline...'),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  progress.epochLabel,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.local_fire_department_rounded, color: AppTheme.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                '${progress.streakDays} day streak',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          XpBar(
            progress: progress.progressToNextLevel,
            totalXP: progress.xp,
            xpToNext: progress.xpToNextLevel,
            color: AppTheme.primaryContainer,
            animDelayMs: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppTheme.onSurface,
      ),
    );
  }

  Widget _buildErasCarousel(BuildContext context) {
    final eras = featuredEras;
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: eras.length,
        itemBuilder: (context, index) {
          final era = eras[index];
          return Container(
            width: 130,
            margin: const EdgeInsets.only(right: 12),
            child: AnimatedCard(
              onTap: () => context.push('/era-details', extra: era),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DynamicPlaceImage(
                      query: era.eraName,
                      placeId: 'era_${era.id}',
                      fallbackUrl: era.outerImage.isNotEmpty ? era.outerImage : null,
                      width: 130,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.65)],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          era.eraName,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Quick Access'),
        const SizedBox(height: 14),
        _buildActionCard(
          context: context,
          title: 'Chat with Historians',
          subtitle: 'Converse with historical figures',
          icon: Icons.history_edu_rounded,
          accentColor: AppTheme.primaryContainer,
          onTap: () => context.push('/personalities-categories'),
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          context: context,
          title: 'Daily Quiz',
          subtitle: 'Test your knowledge • +50 XP',
          icon: Icons.quiz_rounded,
          accentColor: AppTheme.amber,
          onTap: () => context.push('/quiz'),
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          context: context,
          title: 'Saved Collection',
          subtitle: 'Your preserved historical findings',
          icon: Icons.bookmarks_rounded,
          accentColor: AppTheme.primaryContainer,
          onTap: () {
            // Navigate to a dedicated bookmarks page or show overlay
            Navigator.push(context, MaterialPageRoute(builder: (_) => const BookmarksPage()));
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          context: context,
          title: 'Event Explorer',
          subtitle: 'Browse historical events by era',
          icon: Icons.event_note_rounded,
          accentColor: AppTheme.amber,
          onTap: () => context.push('/event-explorer'),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return AnimatedCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outlineVariant, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppTheme.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyFactCard(DailyFactProvider factProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryContainer.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline_rounded, color: AppTheme.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'Did You Know?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            factProvider.factText,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              color: AppTheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Notification Icon with Badge ──────────────────────────────────────────────

class _NotificationIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = context.watch<NotificationProvider>().unreadCount;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: AnimatedButton(
        onTap: () => context.push('/notifications'),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: Icon(
                count > 0
                    ? Icons.notifications_rounded
                    : Icons.notifications_none_rounded,
                color: AppTheme.onSurface,
                size: 22,
              ),
            ),
            if (count > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  decoration: const BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count > 9 ? '9+' : '$count',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
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
