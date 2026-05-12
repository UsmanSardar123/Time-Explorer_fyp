import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/features/explore/presentation/providers/place_provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/gamified_components.dart';
import 'package:timeexplorer/core/widgets/shimmer_box.dart';
import 'package:timeexplorer/core/widgets/fade_slide_in.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/presentation/widgets/place_card.dart';
import 'package:timeexplorer/features/places/presentation/widgets/progress_header.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PlaceProvider>().loadPlaces();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final placeProvider = context.watch<PlaceProvider>();

    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Progress Header (authenticated users only)
            SliverToBoxAdapter(
              child: ProgressHeader(
                totalPlaces: placeProvider.totalPlaces,
                knownPlaceIds: placeProvider.allPlaceIds,
              ),
            ),

            // 2. Top Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildSearchBar(),
              ),
            ),

            // 3. Category / Era Chips
            SliverToBoxAdapter(
              child: _buildCategoryChips(placeProvider),
            ),
            
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const SizedBox(height: 24),
                   _buildSectionTitle('Explore Places'),
                   const SizedBox(height: 16),
                   _buildPlacesGrid(placeProvider),
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
          _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 300), () {
            context.read<PlaceProvider>().setSearchQuery(value);
          });
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
          final accent = cat == 'All'
              ? AppTheme.primaryElectric
              : eraColor(cat, cat);
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AnimatedButton(
              onTap: () => provider.setCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? accent : AppTheme.surfaceLow,
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

    if (provider.places.isEmpty && provider.error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppTheme.outlineVariant),
            const SizedBox(height: 16),
            Text(
              'Could not load places.\nShowing cached content if available.',
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(color: AppTheme.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => context.read<PlaceProvider>().refresh(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.places.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.explore_off_rounded, size: 48, color: AppTheme.outlineVariant),
            const SizedBox(height: 16),
            Text(
              'No places found.',
              style: GoogleFonts.beVietnamPro(color: AppTheme.onSurfaceVariant, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: provider.places.length,
      itemBuilder: (context, index) {
        final pe = provider.places[index];
        final place = Place(
          id: pe.id,
          name: pe.name,
          category: pe.category,
          location: pe.location,
          description: pe.description,
          imageUrl: pe.imageUrl,
          rating: pe.rating,
          era: pe.era,
          history: pe.history,
          builtBy: pe.builtBy,
          civilization: pe.civilization,
          buildType: pe.buildType,
          historicalPeriod: pe.historicalPeriod,
          primaryMaterial: pe.primaryMaterial,
          dimensions: pe.dimensions,
          unescoStatus: pe.unescoStatus,
          purpose: pe.purpose,
          funFacts: pe.funFacts,
        );
        return FadeSlideIn(
          index: index,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: PlaceListCard(place: place),
          ),
        );
      },
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
