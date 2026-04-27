import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/widgets/dynamic_place_image.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/bookmarks/presentation/providers/bookmark_provider.dart';

class PlaceCard extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback? onTap;

  const PlaceCard({
    super.key,
    required this.place,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push('/place-details', extra: place),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Hero(
                tag: 'place-hero-${place.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DynamicPlaceImage(
                      query: place.name,
                      placeId: place.id,
                      fallbackUrl: place.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            place.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<BookmarkProvider>(
                      builder: (context, bookmarkProvider, child) {
                        final isBookmarked = bookmarkProvider.isBookmarked(place.id);
                        return GestureDetector(
                          onTap: () {
                            bookmarkProvider.toggleBookmark(place);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isBookmarked ? 'Removed from bookmarks' : 'Added to bookmarks',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              isBookmarked ? Icons.favorite : Icons.favorite_border,
                              color: isBookmarked ? Colors.red : Colors.grey[700],
                              size: 18,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ],
                ),
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          place.location,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
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
          ],
        ),
      ),
    );
  }
}
