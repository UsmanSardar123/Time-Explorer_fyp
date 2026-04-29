// FILE: lib/features/places/presentation/widgets/nearby_places_widget.dart
// PURPOSE: Horizontal row of compact place cards for nearby places exploration.
// SPRINT: 3 — TASK 3.8

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/widgets/dynamic_place_image.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';

class NearbyPlacesWidget extends StatelessWidget {
  final List<Place> nearbyPlaces;

  const NearbyPlacesWidget({super.key, required this.nearbyPlaces});

  @override
  Widget build(BuildContext context) {
    if (nearbyPlaces.isEmpty) return const SizedBox.shrink();

    final capped = nearbyPlaces.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.explore_rounded, color: Color(0xFF6C63FF), size: 18),
            const SizedBox(width: 8),
            Text(
              'Explore Nearby',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111827),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: capped.length,
            itemBuilder: (context, index) {
              final place = capped[index];
              return _NearbyCard(
                place: place,
                onTap: () => context.push('/place-details', extra: place.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NearbyCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  const _NearbyCard({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              DynamicPlaceImage(
                query: place.name,
                placeId: place.id,
                fallbackUrl: place.imageUrl.isNotEmpty ? place.imageUrl : null,
                fit: BoxFit.cover,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                bottom: 10,
                child: Text(
                  place.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
