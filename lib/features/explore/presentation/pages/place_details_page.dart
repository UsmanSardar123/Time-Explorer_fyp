import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/services/wikimedia_service.dart';
import 'package:timeexplorer/core/services/wikipedia_service.dart';
import 'package:timeexplorer/features/explore/data/datasources/place_scraper_service.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:timeexplorer/features/gamification/domain/entities/game_progress.dart';
import 'package:timeexplorer/features/gamification/presentation/widgets/level_up_overlay.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/themed_loading.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/explore/presentation/providers/place_provider.dart';
import 'package:timeexplorer/features/explore/presentation/widgets/place_image_gallery.dart';

class PlaceDetailsPage extends StatefulWidget {
  final String placeId;

  const PlaceDetailsPage({super.key, required this.placeId});

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  // ── Design Tokens ─────────────────────────────────────────────────────────
  static const _primary = AppTheme.primaryContainer;
  static const _primaryLight = Color(0xFF818CF8);
  static const _bg = AppTheme.background;
  static const _surfaceLow = AppTheme.surfaceLow;
  static const _surfaceCard = AppTheme.surface;
  static const _textDark = AppTheme.textPrimary;
  static const _textMuted = AppTheme.textDimmed;
  static const _accentAmber = AppTheme.amber;

  // ── Preserved State & Services ─────────────────────────────────────────────
  PlaceEntity? _place;
  bool _isExpanded = false;
  String? _fullDescription;
  bool _isLoadingDescription = false;
  final WikimediaService _wikimediaService = WikimediaService();
  int _currentFactIndex = 0;
  int _userRating = 0;
  bool _isPlaying = false;
  bool _xpRewarded = false;
  Timer? _xpTimer;
  final Map<String, String?> _metadataCache = {};

  @override
  void initState() {
    super.initState();
    // In a real app, we'd fetch the place by ID. 
    // For now, I'll assume it's passed or fetched.
    // Preserving the auto-fetch logic.
    _autoFetchMetadata();
    _startTimer();
  }

  void _startTimer() {
    _xpTimer = Timer(const Duration(seconds: 30), () {
      if (!mounted) return;
      if (!_xpRewarded) {
        context.read<GamificationProvider>().processActivity(ActivityType.placeDiscovery);
        setState(() => _xpRewarded = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('+10 XP Earned!'), duration: Duration(seconds: 2)),
        );
      }
    });
  }

  @override
  void dispose() {
    _xpTimer?.cancel();
    super.dispose();
  }

  Future<void> _autoFetchMetadata() async {
    // We need the place entity first.
    // If it's not yet available, we should handle that.
    // To preserve logic, I'll ensure I have a place.
    // (Assuming PlaceProvider provides it)
    final place = _getPlace();
    if (place == null) return;

    _metadataCache['architect'] ??= place.builtBy;
    _metadataCache['timeBuild'] ??= place.yearBuilt;
    _metadataCache['civilization'] ??= place.civilization;
    _metadataCache['buildType'] ??= place.buildType;
    _metadataCache['historicalPeriod'] ??= place.historicalPeriod;
    _metadataCache['primaryMaterial'] ??= place.primaryMaterial;
    _metadataCache['currentLocation'] ??= place.location;
    _metadataCache['dimensions'] ??= place.dimensions;
    _metadataCache['unescoStatus'] ??= place.unescoStatus;
    _metadataCache['purpose'] ??= place.purpose;

    final scraped = await fetchPlaceData(place.name);
    if (!mounted) return;
    setState(() {
      for (final entry in scraped.entries) {
        _metadataCache[entry.key] ??= entry.value;
      }
    });
  }

  PlaceEntity? _getPlace() {
    // Helper to get place from provider by ID
    try {
      return context.read<PlaceProvider>().places.firstWhere((p) => p.id == widget.placeId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _toggleDescription() async {
    final place = _getPlace();
    if (place == null) return;

    if (_isExpanded) {
      setState(() => _isExpanded = false);
      return;
    }

    setState(() => _isExpanded = true);
    if (_fullDescription == null) {
      setState(() => _isLoadingDescription = true);
      final desc = await _wikimediaService.getDescription(place.name);
      if (mounted) {
        setState(() {
          _fullDescription = desc ?? place.description;
          _isLoadingDescription = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final place = _getPlace();
    if (place == null) {
      return const Scaffold(body: ThemedLoading(context: 'events'));
    }

    return LevelUpOverlay(
      child: Scaffold(
        backgroundColor: _bg,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Sliver AppBar
            _buildAppBar(place),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 3. Era + category chips row
                    const SizedBox(height: 20),
                    _buildChipsRow(place),
                    
                    // 4. Key facts horizontal scroll
                    const SizedBox(height: 32),
                    _buildKeyFacts(),
                    
                    // 5. Description section
                    const SizedBox(height: 32),
                    _buildAboutSection(place),
                    
                    // 6. Restyled Feature Sections
                    const SizedBox(height: 32),
                    if (place.funFacts.isNotEmpty) _buildDidYouKnow(place),
                    
                    const SizedBox(height: 32),
                    if (place.timeline.isNotEmpty) _buildTimeline(place),
                    
                    const SizedBox(height: 32),
                    _buildRating(),
                    
                    const SizedBox(height: 32),
                    _buildAudioNarration(place),
                    
                    const SizedBox(height: 32),
                    _buildARStub(),
                    
                    const SizedBox(height: 32),
                    _buildQuizButton(),
                    
                    const SizedBox(height: 32),
                    _buildVisitPlanner(place),
                    
                    const SizedBox(height: 32),
                    _buildSimilarPlaces(),
                    
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(PlaceEntity place) {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      elevation: 0,
      backgroundColor: _primary,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'place_image_${place.id}',
              child: PlaceImageGallery(
                query: place.name,
                fallbackUrl: place.imageUrl,
                height: 350,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppTheme.onSurface],
                  stops: [0.6, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Text(
                place.name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipsRow(PlaceEntity place) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildPillChip(place.era ?? place.category),
          const SizedBox(width: 8),
          _buildPillChip(place.category),
        ],
      ),
    );
  }

  Widget _buildPillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: AppTheme.primaryContainer,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildKeyFacts() {
    final facts = [
      ('Build', _metadataCache['timeBuild'] ?? 'Unknown', Icons.calendar_today),
      ('Era', _metadataCache['historicalPeriod'] ?? _place?.era ?? _place?.category ?? 'Unknown', Icons.history_edu),
      ('Status', _metadataCache['unescoStatus'] != null ? 'UNESCO' : 'Historic', Icons.verified),
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: facts.length,
        itemBuilder: (context, index) {
          final fact = facts[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surfaceLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(fact.$3, color: _primary, size: 20),
                const SizedBox(height: 8),
                Text(
                  fact.$2,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: _textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  fact.$1,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 10,
                    color: _textMuted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAboutSection(PlaceEntity place) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedCrossFade(
          firstChild: Text(
            place.description,
            style: GoogleFonts.beVietnamPro(fontSize: 15, color: _textDark, height: 1.6),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: _isLoadingDescription 
              ? const Center(child: ThemedLoading(context: 'chat'))
              : Text(
                  _fullDescription ?? place.description,
                  style: GoogleFonts.beVietnamPro(fontSize: 15, color: _textDark, height: 1.6),
                ),
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        TextButton(
          onPressed: _toggleDescription,
          child: Text(_isExpanded ? 'Show Less' : 'Read More'),
        ),
      ],
    );
  }

  Widget _buildDidYouKnow(PlaceEntity place) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.amber.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_rounded, color: AppTheme.primaryContainer),
              const SizedBox(width: 12),
              Text(
                'Did You Know?',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            place.funFacts[_currentFactIndex],
            style: GoogleFonts.beVietnamPro(color: AppTheme.textPrimary, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(PlaceEntity place) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Timeline', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        ...place.timeline.map((item) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 2,
                height: 40,
                color: _primaryLight,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['year'] ?? '', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: _primary)),
                  Text(item['event'] ?? '', style: GoogleFonts.beVietnamPro(color: _textMuted)),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < _userRating ? Icons.star_rounded : Icons.star_outline_rounded,
          color: _accentAmber,
          size: 32,
        );
      }),
    );
  }

  Widget _buildAudioNarration(PlaceEntity place) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isPlaying = !_isPlaying),
            child: Container(
              width: 50, height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.primaryGradient,
              ),
              child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Text('Audio Narration', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildARStub() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.onSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.view_in_ar, color: Colors.white),
          const SizedBox(width: 16),
          Text('AR Exploration Coming Soon', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildQuizButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text('Take History Quiz', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _buildVisitPlanner(PlaceEntity place) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: Border.all(color: _primaryLight, width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text('Plan My Visit', style: GoogleFonts.plusJakartaSans(color: _primary, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildSimilarPlaces() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Similar Places', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(color: _surfaceCard, borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}
