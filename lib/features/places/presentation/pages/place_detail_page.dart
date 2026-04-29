import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/presentation/cubit/place_detail_cubit.dart';
import 'package:timeexplorer/features/places/presentation/cubit/place_detail_state.dart';
import 'package:timeexplorer/features/places/presentation/widgets/place_header.dart';
import 'package:timeexplorer/features/places/presentation/widgets/historical_timeline.dart';
import 'package:timeexplorer/features/places/presentation/widgets/location_map_section.dart';
import 'package:timeexplorer/features/places/presentation/widgets/ai_insights_widget.dart';
import 'package:timeexplorer/features/places/presentation/widgets/nearby_places_section.dart';
import 'package:timeexplorer/features/places/presentation/widgets/bridge_to_chat_button.dart';

class PlaceDetailPage extends StatelessWidget {
  final Place place;

  const PlaceDetailPage({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaceDetailCubit(repository: context.read())..loadPlaceDetail(place.id),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: BlocBuilder<PlaceDetailCubit, PlaceDetailState>(
            builder: (context, state) {
              if (state is PlaceDetailLoading) {
                return const Center(child: CircularProgressIndicator(color: AppTheme.primaryElectric));
              }
              if (state is PlaceDetailError) {
                return Center(child: Text(state.message, style: GoogleFonts.plusJakartaSans(color: Colors.redAccent)));
              }
              if (state is PlaceDetailLoaded) {
                final timeline = state.timeline;
                final nearby = state.nearbyPlaces;
                final accentColor = place.colorThemeHex != null
                    ? Color(int.parse(place.colorThemeHex!.replaceFirst('#', '0xFF')))
                    : AppTheme.primaryElectric;
                return CustomScrollView(
                  slivers: [
                    PlaceHeader(
                      id: place.id,
                      name: place.name,
                      category: place.category,
                      location: place.location,
                      imageUrl: place.imageUrl,
                      tag: 'place_hero_${place.id}',
                      description: place.description,
                      history: place.history,
                      rating: place.rating,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(place.description, style: GoogleFonts.beVietnamPro(fontSize: 16, color: AppTheme.textHighContrast, height: 1.5)),
                            const SizedBox(height: 24),
                            if (timeline.isNotEmpty) HistoricalTimeline(events: timeline, accentColor: accentColor),
                            const SizedBox(height: 24),
                            LocationMapSection(latitude: place.latitude, longitude: place.longitude, location: place.location),
                            const SizedBox(height: 24),
                            AiInsightsWidget(place: place),
                            const SizedBox(height: 24),
                            if (nearby.isNotEmpty) NearbyPlacesSection(
                              places: nearby,
                              onPlaceTap: (id) => context.push('/places/$id'),
                            ),
                            const SizedBox(height: 24),
                            BridgeToChatButton(placeId: place.id),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
