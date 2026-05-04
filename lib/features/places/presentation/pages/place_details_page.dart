import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeexplorer/features/places/data/datasources/places_remote_data_source.dart';
import 'package:timeexplorer/features/places/data/repositories/places_repository_impl.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/domain/usecases/get_nearby_places.dart';
import 'package:timeexplorer/features/places/domain/usecases/get_place_details.dart';
import 'package:timeexplorer/features/places/presentation/cubit/place_details_cubit.dart';
import 'package:timeexplorer/features/places/presentation/cubit/place_details_state.dart';
import 'package:timeexplorer/core/widgets/app_cached_image.dart';
import 'package:timeexplorer/core/widgets/dynamic_place_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/features/bookmarks/presentation/providers/bookmark_provider.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart' as explore;
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/tap_scale.dart';
import 'package:timeexplorer/features/places/presentation/widgets/place_card.dart' show eraColor;
import 'package:timeexplorer/features/places/presentation/widgets/place_gallery_widget.dart';
import 'package:timeexplorer/features/places/presentation/widgets/facts_carousel.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:timeexplorer/features/places/presentation/widgets/historical_timeline.dart';
import 'package:timeexplorer/features/places/presentation/widgets/ai_insights_widget.dart';
import 'package:timeexplorer/features/places/presentation/widgets/associated_characters_widget.dart';
import 'package:timeexplorer/features/places/presentation/widgets/nearby_places_widget.dart';
import 'package:timeexplorer/features/places/data/services/user_progress_service.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:timeexplorer/features/quiz/domain/entities/quiz_topic.dart';
import 'package:timeexplorer/features/quiz/presentation/widgets/difficulty_selection_section.dart';

class PlaceDetailsPage extends StatefulWidget {
  final String placeId;

  const PlaceDetailsPage({super.key, required this.placeId});

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  DifficultyLevel? _selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaceDetailsCubit(
        getPlaceDetails: GetPlaceDetailsUseCase(
          PlacesRepositoryImpl(remoteDataSource: PlacesRemoteDataSourceImpl()),
        ),
        getNearbyPlaces: GetNearbyPlacesUseCase(
          PlacesRepositoryImpl(remoteDataSource: PlacesRemoteDataSourceImpl()),
        ),
      )..loadPlaceDetails(widget.placeId),
      child: BlocConsumer<PlaceDetailsCubit, PlaceDetailsState>(
        listenWhen: (prev, curr) =>
            curr is PlaceDetailsLoaded && prev is! PlaceDetailsLoaded,
        listener: (context, state) {
          if (state is PlaceDetailsLoaded) {
            final id = state.place.id;
            UserProgressService().recordPlaceExplored(id);
            context.read<GamificationProvider>().recordPlaceDiscovered(id);
          }
        },
        builder: (context, state) {
          if (state is PlaceDetailsInitial || state is PlaceDetailsLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is PlaceDetailsError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 20),
                    Text('Error: ${state.message}', textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.read<PlaceDetailsCubit>().loadPlaceDetails(widget.placeId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is PlaceDetailsLoaded) {
            final place = state.place;

            final accentColor = place.colorThemeHex != null
                ? Color(int.parse(
                    place.colorThemeHex!.replaceFirst('#', '0xFF')))
                : eraColor(place.era, place.category);

            return Scaffold(
              backgroundColor: AppTheme.scaffoldBackgroundColor,
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(context, place),
                  SliverToBoxAdapter(
                    child: Container(height: 8, color: accentColor),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAnimatedSection(child: _buildHistoricHeader(place), delay: 0),
                          const SizedBox(height: 32),
                          _buildAnimatedSection(child: _buildSectionTitle('Overview'), delay: 100),
                          const SizedBox(height: 12),
                          _buildAnimatedSection(child: _buildHistoricalOverview(place), delay: 200),
                          const SizedBox(height: 24),
                          _buildAnimatedSection(child: _buildTalkToLocalButton(context, place), delay: 250),
                          const SizedBox(height: 32),
                          _buildAnimatedSection(child: _buildSectionTitle('Gallery'), delay: 300),
                          const SizedBox(height: 16),
                          _buildAnimatedSection(
                            child: PlaceGalleryWidget(
                              imageUrls: place.imageUrls,
                              imageCaptions: place.imageCaptions,
                              heroTag: 'place_cover_${place.id}',
                              accentColor: accentColor,
                              placeName: place.name,
                            ),
                            delay: 400,
                          ),
                          const SizedBox(height: 32),
                          if (place.timeline != null && place.timeline!.isNotEmpty) ...[
                            _buildAnimatedSection(child: _buildSectionTitle('Historical Timeline'), delay: 500),
                            const SizedBox(height: 16),
                            _buildAnimatedSection(
                              child: HistoricalTimeline(
                                events: place.timeline!,
                                accentColor: accentColor,
                              ),
                              delay: 600,
                            ),
                            const SizedBox(height: 32),
                          ],
                          _buildAnimatedSection(child: _buildSectionTitle('Quick Facts'), delay: 700),
                          const SizedBox(height: 16),
                          _buildAnimatedSection(child: _buildInfoGrid(place), delay: 800),
                          const SizedBox(height: 24),
                          _buildAnimatedSection(child: _buildTimeTravelWeather(place), delay: 850),
                          const SizedBox(height: 32),
                          if (place.significance != null || place.historicalSignificance != null) ...[
                            _buildAnimatedSection(child: _buildSectionTitle('Historical Significance'), delay: 900),
                            const SizedBox(height: 12),
                            _buildAnimatedSection(child: _buildSignificanceCard(place), delay: 1000),
                            const SizedBox(height: 32),
                          ],
                          if ((place.facts ?? place.funFacts ?? []).isNotEmpty) ...[
                            _buildAnimatedSection(child: _buildSectionTitle('Facts'), delay: 1100),
                            const SizedBox(height: 16),
                            _buildAnimatedSection(
                              child: FactsCarousel(
                                facts: place.facts ?? place.funFacts ?? [],
                                accentColor: accentColor,
                              ),
                              delay: 1200,
                            ),
                            const SizedBox(height: 32),
                          ],
                          _buildAnimatedSection(
                            child: AiInsightsWidget(place: place),
                            delay: 1300,
                          ),
                          const SizedBox(height: 32),
                          _buildAnimatedSection(child: _buildQuizSection(place), delay: 1400),
                          const SizedBox(height: 32),
                          _buildAnimatedSection(child: _buildMapIntegration(place), delay: 1600),
                          const SizedBox(height: 32),
                          if ((place.associatedCharacterIds ?? []).isNotEmpty) ...[
                            _buildAnimatedSection(
                              child: AssociatedCharactersWidget(
                                characterIds: place.associatedCharacterIds!,
                                placeName: place.name,
                              ),
                              delay: 1700,
                            ),
                            const SizedBox(height: 32),
                          ],
                          _buildAnimatedSection(
                            child: NearbyPlacesWidget(nearbyPlaces: state.nearbyPlaces),
                            delay: 1800,
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Scaffold(body: SizedBox.shrink());
        },
      ),
    );
  }

  Widget _buildAnimatedSection({required Widget child, required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Place place) {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      elevation: 0,
      backgroundColor: AppTheme.deepNavy,
      leading: TapScale(
        scale: 0.85,
        haptic: true,
        onTap: () => context.pop(),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: null,
        ),
      ),
      actions: [
        Consumer<BookmarkProvider>(
          builder: (context, bookmarkProvider, child) {
            final isSaved = bookmarkProvider.isBookmarked(place.id);
            return TapScale(
              scale: 0.82,
              haptic: true,
              onTap: () {
                final entity = explore.PlaceEntity(
                  id: place.id,
                  name: place.name,
                  description: place.description,
                  imageUrl: place.imageUrl,
                  category: place.category,
                  location: place.location,
                  rating: place.rating,
                );
                bookmarkProvider.toggleBookmark(entity);
              },
              child: IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isSaved ? AppTheme.accentOrange : Colors.white,
                ),
                onPressed: null,
              ),
            );
          },
        ),
        TapScale(
          scale: 0.82,
          haptic: true,
          onTap: () => Share.share(
            'Explore the secrets of ${place.name} with me on Time Explorer! 🏛️✨\n\nLocation: ${place.location}\nEra: ${place.era ?? place.category}',
            subject: 'Check out ${place.name} on Time Explorer',
          ),
          child: const IconButton(
            icon: Icon(Icons.share_rounded, color: Colors.white),
            onPressed: null,
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'place-hero-${place.id}',
              child: DynamicPlaceImage(
                query: place.name,
                placeId: place.id,
                fallbackUrl: place.imageUrl.isNotEmpty ? place.imageUrl : null,
                fit: BoxFit.cover,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 1.0],
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      place.category.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    place.name,
                    style: GoogleFonts.merriweather(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        place.location,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF111827),
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildHistoricalOverview(Place place) {
    return Text(
      place.history ?? place.description,
      style: GoogleFonts.poppins(
        fontSize: 15,
        height: 1.7,
        color: const Color(0xFF4B5563),
      ),
    );
  }

  Widget _buildHistoricHeader(Place place) {
    return Row(
      children: [
        _buildHeaderStat('ERA', place.era ?? place.historicalPeriod ?? place.category),
        _buildVerticalDivider(),
        _buildHeaderStat('RATING', '${place.rating} ★'),
        _buildVerticalDivider(),
        _buildHeaderStat('SAVED', '2.4k'),
      ],
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F2937),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.grey[200],
    );
  }

  Widget _buildInfoGrid(Place place) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildInfoTile(Icons.account_balance_rounded, 'CIVILIZATION', place.civilization ?? 'Unknown'),
              _buildInfoTile(Icons.architecture_rounded, 'STYLE', place.architecturalStyle ?? 'Classical'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, color: Colors.grey[100]),
          ),
          Row(
            children: [
              _buildInfoTile(Icons.person_rounded, 'BUILT BY', place.builtBy ?? 'Unknown'),
              _buildInfoTile(Icons.calendar_today_rounded, 'DATE', place.constructionDate ?? 'TBA'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, color: Colors.grey[100]),
          ),
          Row(
            children: [
              _buildInfoTile(Icons.public_rounded, 'COUNTRY', place.country ?? 'Unknown'),
              _buildInfoTile(Icons.verified_rounded, 'UNESCO', place.unescoStatus ?? 'Not Listed'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF374151),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignificanceCard(Place place) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF3F4F6),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote_rounded, color: AppTheme.primaryColor, size: 24),
          const SizedBox(height: 12),
          Text(
            place.significance ?? place.historicalSignificance ?? 'Loading analysis...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.6,
              color: const Color(0xFF4B5563),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSection(Place place) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome_rounded, color: AppTheme.primaryColor, size: 24),
            const SizedBox(width: 12),
            Text(
              'Knowledge Check',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.deepNavy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Master the history of ${place.name} by choosing your challenge level.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 24),
        DifficultySelectionSection(
          title: 'Challenge Level',
          subtitle: 'Choose how deep you want to go',
          onDifficultySelected: (level) {
            setState(() => _selectedDifficulty = level);
          },
          onStart: () {
            context.push(
              '/quiz-play',
              extra: QuizTopic(
                title: 'Place_${place.id}',
                description: 'Knowledge check for ${place.name}',
                imageUrl: place.imageUrl,
                icon: Icons.place_rounded,
                color: AppTheme.primaryColor,
                difficultyLevel: _selectedDifficulty!,
                epochCategory: EpochCategory.global,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMapIntegration(Place place) {
    if (place.latitude == null || place.longitude == null) {
      return const SizedBox.shrink();
    }

    final latLng = LatLng(place.latitude!, place.longitude!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Location'),
            TextButton.icon(
              onPressed: () async {
                final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              icon: const Icon(Icons.directions_rounded, size: 16, color: AppTheme.primaryColor),
              label: Text(
                'Directions',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: latLng,
                initialZoom: 13.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.timeexplorer.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: latLng,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: AppTheme.primaryColor,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTalkToLocalButton(BuildContext context, Place place) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.accentOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/local-guide', extra: place),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.forum_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  'Talk to a Local',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeTravelWeather(Place place) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_sync_rounded, color: AppTheme.primaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                'Time-Travel Climate',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'During the ${place.historicalPeriod ?? place.eraLabel ?? "ancient times"}, the climate around ${place.name} was likely different from today. AI analysis suggests the environment was more suited for the civilization that built it.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.6,
              color: const Color(0xFF4B5563),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}








