import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/dynamic_place_image.dart';
import 'package:timeexplorer/core/services/wikimedia_service.dart';
import 'package:timeexplorer/features/explore/domain/entities/personality_entity.dart';
import 'package:timeexplorer/features/personalities/data/datasources/character_local_data_source.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character_category.dart';

class PersonalityDetailsPage extends StatefulWidget {
  final PersonalityEntity personality;

  const PersonalityDetailsPage({super.key, required this.personality});

  @override
  State<PersonalityDetailsPage> createState() => _PersonalityDetailsPageState();
}

class _PersonalityDetailsPageState extends State<PersonalityDetailsPage> {
  // ── Design Tokens ─────────────────────────────────────────────────────────
  static const _primary = AppTheme.primaryContainer;
  static const _primaryLight = Color(0xFF818CF8);
  static const _surfaceLow = AppTheme.surfaceLow;
  static const _textDark = AppTheme.onSurface;
  static const _textMuted = AppTheme.onSurfaceVariant;
  static const _accentAmber = AppTheme.amber;

  // ── Preserved State ───────────────────────────────────────────────────────
  bool _isExpanded = false;
  String? _fullDescription;
  bool _isLoadingDescription = false;
  final WikimediaService _wikimediaService = WikimediaService();
  bool _isButtonPressed = false;

  Character? _richCharacter;

  @override
  void initState() {
    super.initState();
    // Try to map explore entity to the rich local data source character
    _richCharacter = CharacterLocalDataSource().getAll().where((c) {
      final query = widget.personality.name.toLowerCase();
      return c.name.toLowerCase().contains(query);
    }).firstOrNull;
  }

  Future<void> _toggleDescription() async {
    if (_isExpanded) {
      setState(() => _isExpanded = false);
      return;
    }
    setState(() => _isExpanded = true);
    if (_fullDescription == null) {
      setState(() => _isLoadingDescription = true);
      final desc = await _wikimediaService.getDescription(widget.personality.name);
      if (mounted) {
        setState(() {
          _fullDescription = desc ?? _richCharacter?.description ?? widget.personality.description;
          _isLoadingDescription = false;
        });
      }
    }
  }

  String get _profession => _richCharacter?.title ?? 'Historical Figure';
  String get _era => _richCharacter != null ? '${_richCharacter!.dob} - ${_richCharacter!.dod}' : widget.personality.era;
  String get _area => _inferArea(widget.personality.era, _richCharacter?.name);

  // Simple location inference fallback
  String _inferArea(String era, String? name) {
    final lower = name?.toLowerCase() ?? '';
    if (lower.contains('cleopatra') || lower.contains('ramses')) return 'Ancient Egypt';
    if (lower.contains('caesar') || lower.contains('aurelius')) return 'Roman Empire';
    if (lower.contains('einstein') || lower.contains('tesla')) return 'Global / West';
    if (lower.contains('shirazi') || lower.contains('khayyam')) return 'Persia';
    if (era.toLowerCase().contains('ancient')) return 'Ancient World';
    return 'Historical Region';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeroSection(),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailsList(),
                  
                  const SizedBox(height: 32),
                  
                  _buildBiographyCard(),
                  
                  const SizedBox(height: 48),
                  
                  _buildChatButton(),
                  
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: Colors.black45,
          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18)
        ),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            DynamicPlaceImage(
              query: widget.personality.name,
              fallbackUrl: _richCharacter?.imageUrl ?? widget.personality.imageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.1), Colors.black.withValues(alpha: 0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChip(_profession, _accentAmber),
                  const SizedBox(height: 12),
                  Text(
                    widget.personality.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppTheme.primaryContainer,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDetailsList() {
    return Column(
      children: [
        _buildSimpleDetailRow(Icons.history_edu_rounded, 'Era', _era),
        const SizedBox(height: 16),
        _buildSimpleDetailRow(Icons.map_rounded, 'Region', _area),
        if (_richCharacter != null && _richCharacter!.contributions.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSimpleDetailRow(Icons.star_rounded, 'Legacy', '${_richCharacter!.contributions.length} Key Contributions'),
        ],
      ],
    );
  }

  Widget _buildSimpleDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _surfaceLow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _primary, size: 18),
        ),
        const SizedBox(width: 16),
        Text(
          '$label:',
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textMuted,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBiographyCard() {
    final defaultDesc = _richCharacter?.description ?? widget.personality.description;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Biography',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 16),
        _isLoadingDescription 
          ? const Center(child: CircularProgressIndicator())
          : Text(
              _isExpanded ? (_fullDescription ?? defaultDesc) : defaultDesc,
              style: GoogleFonts.beVietnamPro(
                fontSize: 15,
                color: _textMuted,
                height: 1.7,
              ),
              maxLines: _isExpanded ? null : 6,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: _toggleDescription,
            icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, color: _primary),
            label: Text(
              _isExpanded ? 'Show Less' : 'Read Full History', 
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: _primary)
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isButtonPressed = true),
      onTapUp: (_) {
        setState(() => _isButtonPressed = false);
        if (_richCharacter != null) {
          context.push('/personality-chat', extra: _richCharacter);
        } else {
          // Wrap explore personality in Character if missing
          final fallbackChar = Character(
            id: widget.personality.id,
            name: widget.personality.name,
            imageUrl: widget.personality.imageUrl,
            description: widget.personality.description,
            title: 'Historical Figure',
            dob: widget.personality.era,
            dod: 'Unknown',
            contributions: const [],
            facts: const [],
            chatPrompt: 'You are ${widget.personality.name}. Speak in character naturally.',
            category: CharacterCategory.leaders,
            bio: widget.personality.description,
            era: widget.personality.era,
            origin: 'Unknown',
            specialties: const [],
            quiz: const [],
          );
          context.push('/personality-chat', extra: fallbackChar);
        }
      },
      onTapCancel: () => setState(() => _isButtonPressed = false),
      child: AnimatedScale(
        scale: _isButtonPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_primary, _primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Text(
                'Converse with ${widget.personality.name.split(" ").first}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

