import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/features/places/domain/entities/era.dart';
import 'package:timeexplorer/features/places/presentation/providers/era_provider.dart';
import 'package:timeexplorer/core/widgets/dynamic_place_image.dart';
import 'package:timeexplorer/features/bookmarks/presentation/providers/bookmark_provider.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';

class EraDetailsPage extends StatefulWidget {
  final Era era;

  const EraDetailsPage({super.key, required this.era});

  @override
  State<EraDetailsPage> createState() => _EraDetailsPageState();
}

class _EraDetailsPageState extends State<EraDetailsPage> {
  // ── Design Tokens ─────────────────────────────────────────────────────────
  static const _primary = AppTheme.primaryContainer;
  static const _bg = AppTheme.background;
  static const _surfaceLow = AppTheme.surfaceLow;
  static const _textDark = AppTheme.onSurface;
  static const _textMuted = AppTheme.onSurfaceVariant;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EraProvider>().loadPlacesForEra(widget.era.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Hero Image Header
          _buildSliverAppBar(),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Era Info
                  _buildEraInfo(),
                  const SizedBox(height: 32),
                  
                  // 3. Descriptive Section
                  Text(
                    'HISTORICAL CHRONICLE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: _primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.era.detailedDescription,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      color: _textMuted,
                      height: 1.7,
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // 4. Places Section
                  Text(
                    'Landmarks of this Era',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Coordinates of humanity\'s greatest feats',
                    style: GoogleFonts.beVietnamPro(fontSize: 14, color: _textMuted),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // 5. Grid of Places
          _buildPlacesGrid(),
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: _textDark,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            DynamicPlaceImage(
              query: widget.era.eraName,
              placeId: 'era_${widget.era.id}',
              fallbackUrl: widget.era.innerImage.isNotEmpty ? widget.era.innerImage : null,
              width: double.infinity,
              height: 320,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    _textDark.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Text(
                widget.era.eraName,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEraInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _textDark.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: _surfaceLow, shape: BoxShape.circle),
            child: const Icon(Icons.hourglass_bottom_rounded, color: _primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.era.timePeriod,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _textDark,
                  ),
                ),
                Text(
                  'Chronological Horizon',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.beVietnamPro(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacesGrid() {
    return Consumer<EraProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingPlaces) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator(color: _primary)),
          );
        }

        final locations = provider.currentEraPlaces;
        if (locations.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text('No exploration data for this era.', style: GoogleFonts.beVietnamPro(color: _textMuted)),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final loc = locations[index];
                // Build a PlaceEntity-compatible object for bookmark
                final placeEntity = PlaceEntity(
                  id: loc.id,
                  name: loc.name,
                  description: loc.description,
                  imageUrl: loc.imageUrl,
                  category: loc.category,
                  rating: 0.0,
                  location: loc.location,
                  era: widget.era.eraName,
                );
                return GestureDetector(
                  onTap: () => context.push('/place-details', extra: loc.id),
                  child: Container(
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            DynamicPlaceImage(
                              query: loc.name,
                              placeId: loc.id,
                              fallbackUrl: loc.imageUrl.isNotEmpty ? loc.imageUrl : null,
                              fit: BoxFit.cover,
                            ),
                            // Heart bookmark button — topmost, receives taps first
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Consumer<BookmarkProvider>(
                                builder: (context, bookmarkProvider, _) {
                                  final isBookmarked = bookmarkProvider.isBookmarked(loc.id);
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      bookmarkProvider.toggleBookmark(placeEntity);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(isBookmarked
                                              ? 'Removed from collection'
                                              : 'Saved to collection ❤️'),
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: AppTheme.primaryContainer,
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.15),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          isBookmarked
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_border_rounded,
                                          color: isBookmarked
                                              ? AppTheme.primaryContainer
                                              : Colors.grey[600],
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  loc.name,
                                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  loc.location,
                                  style: GoogleFonts.beVietnamPro(fontSize: 11, color: _textMuted),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                          ),
                        ),
                      ),
                    ], // closes children
                  ), // closes Column
                ), // closes Container
              ); // closes GestureDetector
              },
              childCount: locations.length,
            ),
          ),
        );
      },
    );
  }
}
