import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/bookmarks/presentation/providers/bookmark_provider.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:timeexplorer/features/quiz/domain/entities/quiz_topic.dart';
import 'package:timeexplorer/features/quiz/presentation/widgets/difficulty_selection_section.dart';
import '../../domain/entities/character.dart';
import '../widgets/character_info_panel.dart';

class PersonalityDetailPage extends StatefulWidget {
  final Character character;
  const PersonalityDetailPage({super.key, required this.character});

  @override
  State<PersonalityDetailPage> createState() => _PersonalityDetailPageState();
}

class _PersonalityDetailPageState extends State<PersonalityDetailPage> {
  DifficultyLevel? _selectedDifficulty;

  Widget _buildQuizSection(Character character) {
    return DifficultySelectionSection(
      title: 'Interactive Quiz',
      subtitle: 'Test your knowledge about ${character.name.split(' ').last}',
      onDifficultySelected: (level) {
        setState(() => _selectedDifficulty = level);
      },
      onStart: () {
        context.push(
          '/quiz-play',
          extra: QuizTopic(
            title: 'Char_${character.id}',
            description: 'Knowledge check for ${character.name}',
            imageUrl: character.imageUrl,
            icon: Icons.person_rounded,
            color: AppTheme.primary,
            difficultyLevel: _selectedDifficulty!,
            epochCategory: EpochCategory.global,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _HeroAppBar(character: character),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CharacterInfoPanel(character: character),
                  const SizedBox(height: 32),
                  CharacterIntelligencePanel(character: character),
                  const SizedBox(height: 20),
                  _buildQuizSection(character),
                  const SizedBox(height: 40),
                  _PulsingChatButton(character: character),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero App Bar ───────────────────────────────────────────────────────────────

class _HeroAppBar extends StatelessWidget {
  final Character character;
  const _HeroAppBar({required this.character});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 310,
      pinned: true,
      stretch: true,
      backgroundColor: AppTheme.primary,
      leading: const _BackButton(),
      actions: [_BookmarkButton(character: character)],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: _HeroBanner(character: character),
      ),
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  final Character character;
  const _BookmarkButton({required this.character});

  @override
  Widget build(BuildContext context) {
    final bp = context.watch<BookmarkProvider>();
    final saved = bp.isCharacterBookmarked(character.id);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.black45,
        child: IconButton(
          icon: Icon(
            saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: saved ? Colors.amber : Colors.white,
            size: 20,
          ),
          onPressed: () => bp.toggleCharacterBookmark(character),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.black45,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 17),
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final Character character;
  const _HeroBanner({required this.character});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'character_${character.id}',
          child: character.imageUrl.isEmpty
              ? Container(
                  color: AppTheme.surfaceLow,
                  child: const Icon(Icons.person_rounded, color: Colors.white24, size: 80),
                )
              : CachedNetworkImage(
                  imageUrl: character.imageUrl,
                  httpHeaders: const {
                    'User-Agent': 'TimeExplorer/1.0 (Flutter)',
                    'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                  },
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppTheme.surfaceLow),
                  errorWidget: (_, __, ___) => Container(
                    color: AppTheme.surfaceLow,
                    child: const Icon(Icons.person_rounded, color: Colors.white24, size: 80),
                  ),
                ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.35, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  character.era.toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                character.name,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// ── Pulsing Chat Button ────────────────────────────────────────────────────────

class _PulsingChatButton extends StatefulWidget {
  final Character character;
  const _PulsingChatButton({required this.character});

  @override
  State<_PulsingChatButton> createState() => _PulsingChatButtonState();
}

class _PulsingChatButtonState extends State<_PulsingChatButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _glow = Tween<double>(begin: 0.30, end: 0.55).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.character.name.split(' ').last;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Transform.scale(
        scale: _scale.value,
        child: GestureDetector(
          onTap: () {
            context.read<GamificationProvider>().recordPersonalityInteraction(widget.character.id);
            context.push('/personality-chat', extra: widget.character);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: AppTheme.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: _glow.value * 0.4),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Chat with $name',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Character Intelligence Panel ──────────────────────────────────────────────

class CharacterIntelligencePanel extends StatefulWidget {
  final Character character;
  const CharacterIntelligencePanel({super.key, required this.character});

  @override
  State<CharacterIntelligencePanel> createState() => _CharacterIntelligencePanelState();
}

class _CharacterIntelligencePanelState extends State<CharacterIntelligencePanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology_outlined, color: AppTheme.primary, size: 20),
            ),
            title: Text(
              'Intelligence Profile',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          if (_isExpanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: AppTheme.outlineVariant, height: 1),
                  const SizedBox(height: 20),
                  _InfoRow(label: 'Era', value: widget.character.era),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Origin', value: widget.character.origin),
                  const SizedBox(height: 20),
                  Text(
                    'Biography',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.character.bio,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      color: AppTheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.character.specialties
                        .map((s) => _SpecialtyChip(label: s))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12, 
              color: AppTheme.onSurfaceVariant, 
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14, 
              color: AppTheme.onSurface, 
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _SpecialtyChip extends StatelessWidget {
  final String label;
  const _SpecialtyChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12, 
          color: AppTheme.primary, 
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

