import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import '../../domain/entities/historical_event.dart';

// CRASH FIX: IntrinsicHeight + Stack removed.
// Flutter throws "RenderStack does not support returning intrinsic dimensions"
// at runtime whenever this tile appeared in a scrollable layout.
// Replaced with a Column-based connector that has no circular height dependency.
class EventTimelineTile extends StatelessWidget {
  final TimelinePoint point;
  final bool isFirst;
  final bool isLast;
  final Color accentColor;

  const EventTimelineTile({
    super.key,
    required this.point,
    required this.isFirst,
    required this.isLast,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimelineConnector(isFirst: isFirst, isLast: isLast, color: accentColor),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  point.date,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(point.description, style: AppTheme.bodySubtle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineConnector extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final Color color;

  const _TimelineConnector({
    required this.isFirst,
    required this.isLast,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isFirst)
            Container(width: 2, height: 8, color: color.withValues(alpha: 0.30)),
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 6, spreadRadius: 1),
              ],
            ),
          ),
          if (!isLast)
            Container(width: 2, height: 56, color: color.withValues(alpha: 0.30)),
        ],
      ),
    );
  }
}
