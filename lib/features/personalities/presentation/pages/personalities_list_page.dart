import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/themed_loading.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/features/explore/presentation/providers/personality_provider.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character_category.dart';

class PersonalitiesListPage extends StatefulWidget {
  final CharacterCategory category;
  const PersonalitiesListPage({super.key, required this.category});

  @override
  State<PersonalitiesListPage> createState() => _PersonalitiesListPageState();
}

class _PersonalitiesListPageState extends State<PersonalitiesListPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonalityProvider>().loadPersonalities();
    });                                                                                               
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _cardAnim(int index, int total) {
    final count = total == 0 ? 1 : total;
    final start = (index / (count + 1)).clamp(0.0, 1.0);
    final end = ((index + 1) / (count + 1)).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Consumer<PersonalityProvider>(
          builder: (context, provider, _) {
            final characters = provider.getCharactersByCategory(widget.category);
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ListHeader(
                  category: widget.category,
                  count: characters.length,
                  onBack: () => context.pop(),
                ),
                Expanded(
                  child: provider.isLoading && characters.isEmpty
                    ? const ThemedLoading(context: 'categories')
                    : characters.isEmpty
                        ? const Center(child: Text('No legends found in this category.'))
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                            physics: const BouncingScrollPhysics(),
                            itemCount: characters.length,
                            itemBuilder: (context, i) {
                              final anim = _cardAnim(i, characters.length);
                              return FadeTransition(
                                opacity: anim,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.20),
                                    end: Offset.zero,
                                  ).animate(anim),
                                  child: _CharacterCard(
                                    character: characters[i],
                                    rank: i + 1,
                                    onTap: () => context.push('/personality-detail', extra: characters[i]),
                                  ),
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

class _ListHeader extends StatelessWidget {
  final CharacterCategory category;
  final int count;
  final VoidCallback onBack;
  const _ListHeader({required this.category, required this.count, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.onSurface),
            onPressed: onBack,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 0, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(category.icon, color: AppTheme.primaryContainer, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        category.displayName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.onSurface,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _CountChip(count: count),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        category.subtitle,
                        style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppTheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  final int count;
  const _CountChip({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count Legends',
        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }
}

class _CharacterCard extends StatefulWidget {
  final Character character;
  final int rank;
  final VoidCallback onTap;
  const _CharacterCard({required this.character, required this.rank, required this.onTap});

  @override
  State<_CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<_CharacterCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: _CardBody(character: widget.character, rank: widget.rank),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  final Character character;
  final int rank;
  const _CardBody({required this.character, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant),
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
          _AccentBar(category: character.category),
          const SizedBox(width: 14),
          _CardAvatar(character: character, rank: rank),
          const SizedBox(width: 14),
          Expanded(child: _CardInfo(character: character)),
          _ChatHint(contributions: character.contributions.length),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

class _AccentBar extends StatelessWidget {
  final CharacterCategory category;
  const _AccentBar({required this.category});

  static const _colors = {
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
    final colors = _colors[category] ?? [AppTheme.primary, AppTheme.primaryContainer];
    return Container(
      width: 4,
      height: 96,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class _CardAvatar extends StatelessWidget {
  final Character character;
  final int rank;
  const _CardAvatar({required this.character, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Hero(
          tag: 'character_${character.id}',
          child: CircleAvatar(
            radius: 32,
            backgroundColor: AppTheme.surfaceLow,
            child: ClipOval(
              child: character.imageUrl.isEmpty
                  ? _AvatarPlaceholder(category: character.category)
                  : CachedNetworkImage(
                      imageUrl: character.imageUrl,
                      httpHeaders: const {'User-Agent': 'TimeExplorer/1.0 (Flutter)'},
                      width: 64,
                      height: 64,
                      memCacheWidth: 128,
                      memCacheHeight: 128,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 250),
                      fadeInCurve: Curves.easeIn,
                      placeholder: (ctx, url) =>
                          _AvatarPlaceholder(category: character.category),
                      errorWidget: (ctx, url, err) =>
                          _AvatarPlaceholder(category: character.category),
                    ),
            ),
          ),
        ),
        _RankBadge(rank: rank),
      ],
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.primaryGradient,
        border: Border.all(color: AppTheme.surfaceLowest, width: 1.5),
      ),
      child: Center(
        child: Text(
          '$rank',
          style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  final CharacterCategory? category;
  const _AvatarPlaceholder({this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceLow,
      child: Icon(
        category?.icon ?? Icons.person_rounded,
        color: AppTheme.onSurfaceVariant,
        size: 32,
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  final Character character;
  const _CardInfo({required this.character});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            character.name,
            style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.onSurface, height: 1.2),
          ),
          const SizedBox(height: 3),
          Text(
            character.title,
            style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppTheme.onSurfaceVariant),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.timeline_rounded, size: 10, color: AppTheme.outlineVariant),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '${character.dob} – ${character.dod}',
                  style: GoogleFonts.beVietnamPro(fontSize: 10, color: AppTheme.outlineVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatHint extends StatelessWidget {
  final int contributions;
  const _ChatHint({required this.contributions});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryContainer.withValues(alpha: 0.20)),
          ),
          child: const Icon(Icons.chat_bubble_outline_rounded, size: 17, color: AppTheme.primaryContainer),
        ),
        const SizedBox(height: 4),
        Text(
          '$contributions',
          style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppTheme.onSurfaceVariant, fontWeight: FontWeight.w600),
        ),
        Text(
          'contrib.',
          style: GoogleFonts.beVietnamPro(fontSize: 8, color: AppTheme.outlineVariant),
        ),
      ],
    );
  }
}
