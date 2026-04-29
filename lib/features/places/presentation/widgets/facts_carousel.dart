// FILE: lib/features/places/presentation/widgets/facts_carousel.dart
// PURPOSE: Horizontally swipeable PageView carousel of quick facts with era-accented cards.
// SPRINT: 3 — TASK 3.3

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FactsCarousel extends StatefulWidget {
  final List<String> facts;
  final Color accentColor;

  const FactsCarousel({
    super.key,
    required this.facts,
    required this.accentColor,
  });

  @override
  State<FactsCarousel> createState() => _FactsCarouselState();
}

class _FactsCarouselState extends State<FactsCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.facts.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 160,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.facts.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.accentColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_rounded,
                          color: widget.accentColor, size: 20),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Text(
                          widget.facts[index],
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 14,
                            height: 1.5,
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      '${index + 1} / ${widget.facts.length}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: widget.accentColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
