import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/app_image_loader.dart';
import '../../core/category_image_helper.dart';
import '../../domain/entities/historical_event.dart';

class EventCard extends StatelessWidget {
  final HistoricalEvent event;
  final VoidCallback onTap;
  final bool isFavorite;
  final String searchQuery;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.isFavorite = false,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 240,
        margin: const EdgeInsets.symmetric(
            horizontal: AppTheme.spaceMD, vertical: AppTheme.spaceSM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          boxShadow: AppTheme.glowShadow(event.category.color,
              intensity: 0.18, blur: 18),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppImageLoader(
                imageUrl: getCategoryImageAsset(event.category),
                category: event.category,
                heroTag: event.heroTag,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xE6000000)],
                    stops: [0.35, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: _CategoryBadge(event: event),
              ),
              if (isFavorite)
                const Positioned(
                  top: 12,
                  right: 12,
                  child: _FavoriteBadge(),
                ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: _CardContent(event: event, searchQuery: searchQuery),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteBadge extends StatelessWidget {
  const _FavoriteBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.black45,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.bookmark_rounded, color: AppTheme.amber, size: 16),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final HistoricalEvent event;
  const _CategoryBadge({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: event.category.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(event.category.icon, color: Colors.white, size: 11),
          const SizedBox(width: 4),
          Text(
            event.category.displayName,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final HistoricalEvent event;
  final String searchQuery;
  const _CardContent({required this.event, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _HighlightText(
          text: event.title,
          query: searchQuery,
          baseStyle: GoogleFonts.plusJakartaSans(
              fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
          highlightStyle: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.amber),
          maxLines: 2,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                color: Colors.white70, size: 12),
            const SizedBox(width: 4),
            Text(event.period,
                style:
                    GoogleFonts.beVietnamPro(fontSize: 12, color: Colors.white70)),
            const SizedBox(width: 12),
            const Icon(Icons.location_on_outlined,
                color: Colors.white70, size: 12),
            const SizedBox(width: 4),
            Expanded(
              child: Text(event.location,
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 12, color: Colors.white70),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ],
    );
  }
}

class _HighlightText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle baseStyle;
  final TextStyle highlightStyle;
  final int maxLines;

  const _HighlightText({
    required this.text,
    required this.query,
    required this.baseStyle,
    required this.highlightStyle,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text,
          style: baseStyle, maxLines: maxLines, overflow: TextOverflow.ellipsis);
    }
    final lower = text.toLowerCase();
    final queryLower = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    int idx;
    while ((idx = lower.indexOf(queryLower, start)) != -1) {
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx), style: baseStyle));
      }
      spans.add(TextSpan(
          text: text.substring(idx, idx + query.length),
          style: highlightStyle));
      start = idx + query.length;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: baseStyle));
    }
    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
