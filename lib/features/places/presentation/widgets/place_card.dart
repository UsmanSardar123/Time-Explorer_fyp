// FILE: lib/features/places/presentation/widgets/place_card.dart
// PURPOSE: Rich immersive card for the places list with gradient, era badge, and Hero animation.
// SPRINT: 2 — TASK 2.2

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeexplorer/core/widgets/shimmer_box.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/models/place_era.dart';

class PlaceListCard extends StatelessWidget {
  final Place place;

  const PlaceListCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    // Determine the color from the place or fallback
    final colorHex = place.colorThemeHex ?? '#4A6FA5';
    final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));

    return GestureDetector(
      onTap: () => context.push('/place-details', extra: place),
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'place_cover_${place.id}',
                child: CachedNetworkImage(
                  imageUrl: place.imageUrls.isNotEmpty
                      ? place.imageUrls.first
                      : (place.imageUrl.isNotEmpty ? place.imageUrl : 'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?w=800'),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => const ShimmerBox(radius: 0),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.60, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.90),
                    ],
                  ),
                ),
              ),
              // Explored Badge (Sprint 4 preparation)
              // Will add explored badge logic in Sprint 4.
              
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (place.eraLabel ?? place.eraEnum?.value ?? place.era ?? place.category).toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            place.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  color: Colors.white60, size: 12),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  '${place.country ?? ''}${place.country != null && place.city != null ? ', ' : ''}${place.city ?? place.location}',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 12,
                                    color: Colors.white60,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Explore →',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color eraColor(String? era, String category) {
  switch ((era ?? category).toLowerCase()) {
    case 'ancient':
      return const Color(0xFF8D6E63);
    case 'medieval':
      return const Color(0xFF7B68EE);
    case 'renaissance':
      return const Color(0xFFD4A017);
    case 'earlymodern':
    case 'early modern':
    case 'early_modern':
      return const Color(0xFF2E8B57);
    case 'modern':
      return const Color(0xFF1565C0);
    default:
      return const Color(0xFF4A6FA5);
  }
}
