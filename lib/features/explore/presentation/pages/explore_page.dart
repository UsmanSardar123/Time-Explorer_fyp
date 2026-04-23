import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/features/explore/presentation/providers/personality_provider.dart';
import 'package:timeexplorer/features/explore/presentation/providers/place_provider.dart';
import 'package:timeexplorer/core/widgets/dynamic_place_image.dart';
import 'package:timeexplorer/features/explore/presentation/widgets/personality_card.dart';
import 'package:timeexplorer/features/bookmarks/presentation/providers/bookmark_provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/gamified_components.dart';
import 'package:timeexplorer/core/widgets/shimmer_box.dart';
import 'package:timeexplorer/core/widgets/fade_slide_in.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PlaceProvider>().loadPlaces();
        context.read<PersonalityProvider>().loadPersonalities();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final placeProvider = context.watch<PlaceProvider>();
    final personalityProvider = context.watch<PersonalityProvider>();

    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Top Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildSearchBar(),
              ),
            ),
            
            // 2. Category Chips
            SliverToBoxAdapter(
              child: _buildCategoryChips(placeProvider),
            ),
            
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const SizedBox(height: 24),
                   // 3. Explore Places Header
                   _buildSectionTitle('Explore Places'),
                   const SizedBox(height: 16),
                   _buildPlacesGrid(placeProvider),
                   
                   const SizedBox(height: 32),
                   // 5. Personalities Section
                   _buildSectionTitle('Time Legends'),
                   const SizedBox(height: 16),
                   _buildPersonalitiesList(personalityProvider),
                   const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceCyber,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryElectric.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        style: GoogleFonts.plusJakartaSans(color: AppTheme.textHighContrast),
        onChanged: (value) {
          context.read<PlaceProvider>().setSearchQuery(value);
          context.read<PersonalityProvider>().setSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Search history...',
          hintStyle: GoogleFonts.plusJakartaSans(color: AppTheme.textDimmed),
          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryElectric),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppTheme.textDimmed),
                  onPressed: () {
                    _searchController.clear();
                    context.read<PlaceProvider>().setSearchQuery('');
                    context.read<PersonalityProvider>().setSearchQuery('');
                    setState(() {});
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppTheme.primaryElectric, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(PlaceProvider provider) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: provider.categories.length,
        itemBuilder: (context, index) {
          final cat = provider.categories[index];
          final isSelected = cat == provider.selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AnimatedButton(
              onTap: () => provider.setCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: isSelected ? AppTheme.primaryGradient : null,
                  color: isSelected ? null : AppTheme.surfaceLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : AppTheme.outlineVariant,
                  ),
                ),
                child: Text(
                  cat,
                  style: GoogleFonts.plusJakartaSans(
                    color: isSelected ? Colors.white : AppTheme.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppTheme.textHighContrast,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildPlacesGrid(PlaceProvider provider) {
    if (provider.isLoading) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (_, index) => const _PlaceCardShimmer(),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: provider.places.length,
      itemBuilder: (context, index) {
        final place = provider.places[index];
        return FadeSlideIn(
          index: index,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: AnimatedCard(
              onTap: () => context.push('/place-details', extra: place),
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCyber,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Hero(
                              tag: 'place-hero-${place.id}',
                              child: DynamicPlaceImage(
                                query: place.name,
                                fallbackUrl: place.imageUrl.isNotEmpty ? place.imageUrl : null,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      place.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: AppTheme.textHighContrast,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTheme.primaryElectric),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    // Era chip overlay
                    Positioned(
                      top: 150,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: AppTheme.cyberGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          (place.era ?? place.category).toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    // Heart bookmark button — topmost
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Consumer<BookmarkProvider>(
                        builder: (context, bookmarkProvider, _) {
                          final isBookmarked = bookmarkProvider.isBookmarked(place.id);
                          return AnimatedButton(
                            onTap: () {
                              bookmarkProvider.toggleBookmark(place);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isBookmarked
                                      ? 'Removed from history'
                                      : 'Legacy preserved! ❤️'),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: AppTheme.primaryElectric,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0), // increased tap area
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceCyber.withValues(alpha: 0.8),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.primaryElectric.withValues(alpha: 0.2)),
                                ),
                                child: Icon(
                                  isBookmarked
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: isBookmarked
                                      ? AppTheme.accentNeon
                                      : AppTheme.textDimmed,
                                  size: 20,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ), // Close Stack
              ), // Close ClipRRect
            ), // Close Container
          ), // Close GestureDetector
        ), // Close Padding
      ); // FadeSlideIn
    },
  );
}

  Widget _buildPersonalitiesList(PersonalityProvider provider) {
    if (provider.isLoading) {
      return SizedBox(
        height: 220,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (_, index) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ShimmerBox(width: 140, height: 220, radius: 20),
          ),
        ),
      );
    }
    return SizedBox(
      height: 220,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: provider.personalities.length,
        itemBuilder: (context, index) {
          final p = provider.personalities[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: PersonalityCard(
              personality: p,
              onTap: () => context.push('/personality-details', extra: p),
            ),
          );
        },
      ),
    );
  }
}

class _PlaceCardShimmer extends StatelessWidget {
  const _PlaceCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ShimmerBox(height: 210, radius: 0),
            Container(
              height: 70,
              color: const Color(0xFF151B26),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 180, height: 16),
                  const SizedBox(height: 8),
                  ShimmerBox(width: 100, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
