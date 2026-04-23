import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/admin/presentation/manager/admin_provider.dart';
import 'package:timeexplorer/features/auth/presentation/providers/auth_provider.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // ── Design Tokens ─────────────────────────────────────────────────────────
  static const _adminPrimary = Color(0xFF0F172A);
  static const _primary = AppTheme.primaryContainer;
  static const _surfaceCard = AppTheme.surfaceLow;
  static const _textLight = AppTheme.background;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _textLight,
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.stats == null) {
            return const Center(child: CircularProgressIndicator(color: _primary));
          }

          final stats = provider.stats;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Command Header
              SliverToBoxAdapter(child: _buildHeader()),
              
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // 2. Stats Overview
                    _buildStatsGrid(stats),
                    
                    const SizedBox(height: 32),
                    
                    // 3. Management Sections
                    _buildSectionTitle('Management'),
                    _buildAdminAction('Manage Users', Icons.person_search_rounded, () => context.push('/admin/users')),
                    _buildAdminAction('Manage Places', Icons.landscape_rounded, () => context.push('/admin/places')),
                    _buildAdminAction('Manage Characters', Icons.history_edu_rounded, () => context.push('/admin/characters')),

                    const SizedBox(height: 24),
                    _buildSectionTitle('Content'),
                    _buildAdminAction('Historical Facts', Icons.menu_book_rounded, () => context.push('/admin/facts')),
                    
                    const SizedBox(height: 40),
                    _buildCacheButton(provider),
                    const SizedBox(height: 60),
                  ]),
                ),
              ),
            ],
          ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 70, 24, 40),
      color: _adminPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Admin Console',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white70),
                onPressed: () => context.read<AuthProvider>().signOut(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Managing Time Explorer Ecosystem',
            style: GoogleFonts.beVietnamPro(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(dynamic stats) {
    final tiles = [
      ('Users',      '${stats?.totalUsers ?? 0}',           Icons.people_rounded),
      ('Places',     '${stats?.totalPlaces ?? 0}',          Icons.map_rounded),
      ('Characters', '${stats?.totalCharacters ?? 0}',      Icons.history_edu_rounded),
      ('Facts',      '${stats?.totalHistoricalFacts ?? 0}', Icons.auto_stories_rounded),
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: List.generate(tiles.length, (i) {
        final (label, value, icon) = tiles[i];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + i * 100),
          curve: Curves.easeOut,
          builder: (_, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(offset: Offset(0, 16 * (1 - v)), child: child),
          ),
          child: _buildStatTile(label, value, icon),
        );
      }),
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _primary, size: 20),
          const Spacer(),
          Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900)),
          Text(label, style: GoogleFonts.beVietnamPro(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildAdminAction(String label, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: Icon(icon, color: Colors.white),
        title: Text(
          label,
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
      ),
    );
  }

  Widget _buildCacheButton(AdminProvider provider) {
    return Center(
      child: TextButton.icon(
        onPressed: () => provider.clearSystemCache(),
        icon: const Icon(Icons.cleaning_services_rounded, size: 18, color: Colors.black45),
        label: Text(
          'Flush System Cache',
          style: GoogleFonts.plusJakartaSans(color: Colors.black45, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
