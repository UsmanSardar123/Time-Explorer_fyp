import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:timeexplorer/features/explore/presentation/providers/personality_provider.dart';
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

  static const _requiredEpoch = {
    CharacterCategory.leaders: 3,
    CharacterCategory.artists: 5,
    CharacterCategory.writers: 7,
  };

  static void _showLockDialog(BuildContext context, CharacterCategory cat) {
    final colors = _gradients[cat] ?? [AppTheme.primary, AppTheme.primaryContainer];
    final accentColor = colors[0];
    final epoch = _requiredEpoch[cat] ?? 3;
    final emoji = _CardContent._avatarEmoji[cat] ?? '🔒';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CategoryLockSheet(
        category: cat,
        accentColor: accentColor,
        emoji: emoji,
        requiredEpoch: epoch,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = CharacterCategory.values;
    
    // Load personalities on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonalityProvider>().loadPersonalities();
    });

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Consumer<PersonalityProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(
                  onBack: () => context.pop(),
                  totalCategories: categories.length,
                  unlockedCategories: context.watch<GamificationProvider>().progress.visitedCategories.length,
                  totalPersonalities: context.watch<GamificationProvider>().progress.interactedPersonalities.length,
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
                      final count = provider.getCharactersByCategory(cat).length;
                      final isAvailable = _availableCategories.contains(cat);
                      
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
                          colors: _gradients[cat] ?? [AppTheme.primary, AppTheme.primaryContainer],
                          available: isAvailable,
                          requiredEpoch: _requiredEpoch[cat],
                          count: count,
                          onTap: isAvailable
                              ? () {
                                  context.read<GamificationProvider>().recordCategoryExplored(cat.name);
                                  context.push('/personalities-list', extra: cat);
                                }
                              : () => _showLockDialog(context, cat),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  final int totalCategories;
  final int unlockedCategories;
  final int totalPersonalities;
  
  const _Header({
    required this.onBack, 
    required this.totalCategories, 
    required this.unlockedCategories,
    required this.totalPersonalities,
  });

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
                _ProgressBanner(
                  unlockedCategories: unlockedCategories, 
                  totalCategories: totalCategories,
                  personalitiesMet: totalPersonalities,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBanner extends StatelessWidget {
  final int unlockedCategories;
  final int totalCategories;
  final int personalitiesMet;

  const _ProgressBanner({
    required this.unlockedCategories, 
    required this.totalCategories,
    required this.personalitiesMet,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = unlockedCategories / totalCategories;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryContainer.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome_rounded, size: 14, color: AppTheme.primaryContainer),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$personalitiesMet Personalities Met',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    Text(
                      '$unlockedCategories of $totalCategories categories explored',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(ratio * 100).round()}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: AppTheme.outlineVariant.withValues(alpha: 0.5),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryContainer),
              minHeight: 5,
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
  final int? requiredEpoch;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.category,
    required this.colors,
    required this.available,
    required this.count,
    this.requiredEpoch,
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
                builder: (ctx, child) => _CardShell(
                  category: widget.category,
                  colors: widget.colors,
                  available: widget.available,
                  count: widget.count,
                  requiredEpoch: widget.requiredEpoch,
                  glowFactor: _glowAnim!.value,
                ),
              )
            : _CardShell(
                category: widget.category,
                colors: widget.colors,
                available: widget.available,
                count: widget.count,
                requiredEpoch: widget.requiredEpoch,
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
  final int? requiredEpoch;
  final double glowFactor;

  const _CardShell({
    required this.category,
    required this.colors,
    required this.available,
    required this.count,
    this.requiredEpoch,
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
          if (!available) _LockedOverlay(requiredEpoch: requiredEpoch),
          if (!available) _EpochBadge(requiredEpoch: requiredEpoch),
          if (available) _LiveBadge(count: count),
        ],
      ),
    );
  }
}

class _LockedOverlay extends StatelessWidget {
  final int? requiredEpoch;
  const _LockedOverlay({this.requiredEpoch});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          color: Colors.black.withValues(alpha: 0.38),
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 1.5),
            ),
            child: const Icon(Icons.lock_rounded, size: 26, color: Colors.white70),
          ),
        ),
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

  static const _avatarEmoji = {
    CharacterCategory.scientists:   '🔬',
    CharacterCategory.philosophers: '🦉',
    CharacterCategory.emperors:     '👑',
    CharacterCategory.poets:        '📜',
    CharacterCategory.explorers:    '🧭',
    CharacterCategory.leaders:      '⚔️',
    CharacterCategory.artists:      '🎨',
    CharacterCategory.writers:      '✍️',
  };

  @override
  Widget build(BuildContext context) {
    final emoji = _avatarEmoji[category] ?? '⭐';

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: available ? 0.18 : 0.07),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: available ? 0.25 : 0.08),
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 32),
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

class _EpochBadge extends StatelessWidget {
  final int? requiredEpoch;
  const _EpochBadge({this.requiredEpoch});

  @override
  Widget build(BuildContext context) {
    final label = requiredEpoch != null ? 'Epoch $requiredEpoch' : 'Locked';
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_rounded, size: 10, color: Colors.white54),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Category Lock Bottom Sheet ─────────────────────────────────────────────────

class _CategoryLockSheet extends StatelessWidget {
  final CharacterCategory category;
  final Color accentColor;
  final String emoji;
  final int requiredEpoch;

  const _CategoryLockSheet({
    required this.category,
    required this.accentColor,
    required this.emoji,
    required this.requiredEpoch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.12),
                  border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 2),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 36)),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 1.5),
                  ),
                  child: const Icon(Icons.lock_rounded, size: 16, color: Colors.white54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${category.displayName} Locked',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Unlocks at Epoch $requiredEpoch',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Keep exploring eras, completing quizzes,\nand chatting with legends to advance your epoch.',
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: Colors.white54,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt_rounded, color: accentColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Required: Epoch $requiredEpoch',
                  style: GoogleFonts.plusJakartaSans(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                foregroundColor: Colors.white70,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Keep Exploring',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
