import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/gamification/domain/entities/badge.dart' as entity;
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';

class BadgeCollectionPage extends StatelessWidget {
  const BadgeCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: Text(
          'My Collection',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.onSurface,
          ),
        ),
      ),
      body: Consumer<GamificationProvider>(
        builder: (context, gam, _) {
          final all = gam.badges;
          final unlockedCount = all.where((b) => b.isUnlocked).length;
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _Header(unlocked: unlockedCount, total: all.length),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.92,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _BadgeTile(badge: all[i]),
                    childCount: all.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int unlocked;
  final int total;
  const _Header({required this.unlocked, required this.total});

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : unlocked / total;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryContainer.withValues(alpha: 0.18),
              AppTheme.primaryContainer.withValues(alpha: 0.06),
            ],
          ),
          border: Border.all(color: AppTheme.primaryContainer.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🏅', style: TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$unlocked of $total unlocked',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Keep exploring to collect them all!',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 8,
                backgroundColor:
                    AppTheme.primaryContainer.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final entity.Badge badge;
  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    final unlocked = badge.isUnlocked;
    return InkWell(
      onTap: () => _showBadgeSheet(context),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: unlocked
              ? AppTheme.surfaceLowest
              : AppTheme.surfaceLow.withValues(alpha: 0.7),
          border: Border.all(
            color: unlocked
                ? AppTheme.primaryContainer.withValues(alpha: 0.45)
                : AppTheme.outlineVariant,
            width: 1.4,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: unlocked
              ? [
                  BoxShadow(
                    color: AppTheme.primaryContainer.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: unlocked
                    ? AppTheme.primaryContainer.withValues(alpha: 0.18)
                    : AppTheme.surfaceLow,
              ),
              child: Center(
                child: unlocked
                    ? Text(badge.icon, style: const TextStyle(fontSize: 26))
                    : const Icon(Icons.lock_rounded,
                        color: AppTheme.onSurfaceVariant, size: 22),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              badge.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: unlocked
                    ? AppTheme.onSurface
                    : AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              unlocked ? 'Unlocked' : 'Locked',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: unlocked
                    ? AppTheme.primaryContainer
                    : AppTheme.onSurfaceVariant,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _BadgeSheet(badge: badge),
    );
  }
}

class _BadgeSheet extends StatelessWidget {
  final entity.Badge badge;
  const _BadgeSheet({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badge.isUnlocked
                  ? AppTheme.primaryContainer.withValues(alpha: 0.20)
                  : AppTheme.surfaceLow,
            ),
            child: Center(
              child: badge.isUnlocked
                  ? Text(badge.icon, style: const TextStyle(fontSize: 36))
                  : const Icon(Icons.lock_rounded,
                      size: 32, color: AppTheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            badge.name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            badge.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              height: 1.5,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
