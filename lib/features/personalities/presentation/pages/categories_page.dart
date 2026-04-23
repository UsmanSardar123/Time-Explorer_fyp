import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import '../../domain/entities/character_category.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  static const _availableCategories = {
    CharacterCategory.scientists,
    CharacterCategory.philosophers,
    CharacterCategory.emperors,
    CharacterCategory.poets,
    CharacterCategory.explorers,
  };

  static const _categoryCounts = {
    CharacterCategory.scientists:   5,
    CharacterCategory.philosophers: 5,
    CharacterCategory.emperors:     5,
    CharacterCategory.poets:        5,
    CharacterCategory.explorers:    5,
  };

  static const _gradients = {
    CharacterCategory.scientists:   [Color(0xFF1D4ED8), Color(0xFF06B6D4)],
    CharacterCategory.philosophers: [Color(0xFF6D28D9), Color(0xFFDB2777)],
    CharacterCategory.emperors:     [Color(0xFFB91C1C), Color(0xFFD97706)],
    CharacterCategory.poets:        [Color(0xFF065F46), Color(0xFF0891B2)],
    CharacterCategory.explorers:    [Color(0xFF0E7490), Color(0xFF1D4ED8)],
    CharacterCategory.leaders:      [Color(0xFF78350F), Color(0xFFB45309)],
    CharacterCategory.artists:      [Color(0xFFD97706), Color(0xFFF59E0B)],
    CharacterCategory.writers:      [Color(0xFF374151), Color(0xFF6B7280)],
  };

  @override
  Widget build(BuildContext context) {
    final categories = CharacterCategory.values;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(
                onBack: () => context.pop(),
                total: categories.length,
                unlocked: _availableCategories.length,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.86,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    final available = _availableCategories.contains(cat);
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 350 + i * 70),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, child) => Opacity(
                        opacity: v,
                        child: Transform.translate(
                          offset: Offset(0, 22 * (1 - v)),
                          child: child,
                        ),
                      ),
                      child: _CategoryCard(
                        category: cat,
                        colors: _gradients[cat]!,
                        available: available,
                        count: _categoryCounts[cat] ?? 0,
                        onTap: available
                            ? () {
                                context.read<GamificationProvider>().recordCategoryExplored(cat.name);
                                context.push('/personalities-list', extra: cat);
                              }
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  final int total;
  final int unlocked;
  const _Header({required this.onBack, required this.total, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.onSurface),
            onPressed: onBack,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 0, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat with History',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.onSurface,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose a category to meet a legend',
                  style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppTheme.onSurfaceVariant),
                ),
                const SizedBox(height: 14),
                _ProgressBanner(unlocked: unlocked, total: total),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBanner extends StatelessWidget {
  final int unlocked;
  final int total;
  const _ProgressBanner({required this.unlocked, required this.total});

  @override
  Widget build(BuildContext context) {
    final ratio = unlocked / total;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryContainer.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_open_rounded, size: 14, color: AppTheme.primaryContainer),
              const SizedBox(width: 6),
              Text(
                '$unlocked of $total categories unlocked',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryContainer,
                ),
              ),
              const Spacer(),
              Text(
                '${(ratio * 100).round()}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: AppTheme.outlineVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryContainer),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category Card ──────────────────────────────────────────────────────────────

class _CategoryCard extends StatefulWidget {
  final CharacterCategory category;
  final List<Color> colors;
  final bool available;
  final int count;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.category,
    required this.colors,
    required this.available,
    required this.count,
    this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  AnimationController? _glowCtrl;
  Animation<double>? _glowAnim;

  @override
  void initState() {
    super.initState();
    if (widget.available) {
      _glowCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800),
      )..repeat(reverse: true);
      _glowAnim = CurvedAnimation(parent: _glowCtrl!, curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    _glowCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: _glowAnim != null
            ? AnimatedBuilder(
                animation: _glowAnim!,
                builder: (_, __) => _CardShell(
                  category: widget.category,
                  colors: widget.colors,
                  available: widget.available,
                  count: widget.count,
                  glowFactor: _glowAnim!.value,
                ),
              )
            : _CardShell(
                category: widget.category,
                colors: widget.colors,
                available: widget.available,
                count: widget.count,
                glowFactor: 0,
              ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final CharacterCategory category;
  final List<Color> colors;
  final bool available;
  final int count;
  final double glowFactor;

  const _CardShell({
    required this.category,
    required this.colors,
    required this.available,
    required this.count,
    required this.glowFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: available
              ? colors
              : [AppTheme.surfaceHigh, AppTheme.surfaceHighest],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: available
            ? [
                BoxShadow(
                  color: colors[0].withValues(alpha: 0.25 + 0.20 * glowFactor),
                  blurRadius: 18 + 10 * glowFactor,
                  spreadRadius: glowFactor * 2,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Stack(
        children: [
          _CardContent(category: category, available: available, count: count),
          if (!available) const _ComingSoonBadge(),
          if (available) _LiveBadge(count: count),
        ],
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final CharacterCategory category;
  final bool available;
  final int count;
  const _CardContent({
    required this.category,
    required this.available,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: available ? 0.20 : 0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              category.icon,
              color: available ? Colors.white : AppTheme.onSurfaceVariant,
              size: 30,
            ),
          ),
          const Spacer(),
          Text(
            category.displayName,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: available ? Colors.white : AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            category.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.beVietnamPro(
              fontSize: 10.5,
              color: available ? Colors.white.withValues(alpha: 0.8) : AppTheme.outlineVariant,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  final int count;
  const _LiveBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4ADE80),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonBadge extends StatelessWidget {
  const _ComingSoonBadge();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Text(
          'Soon',
          style: GoogleFonts.poppins(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: Colors.white38,
          ),
        ),
      ),
    );
  }
}
