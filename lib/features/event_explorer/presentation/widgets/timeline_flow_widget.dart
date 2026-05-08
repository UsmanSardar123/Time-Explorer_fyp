import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import '../../domain/entities/historical_event.dart';

class TimelineFlowWidget extends StatelessWidget {
  final List<HistoricalEvent> events;
  final void Function(HistoricalEvent) onTap;

  const TimelineFlowWidget({
    super.key,
    required this.events,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: events.length,
      itemBuilder: (_, i) => _TimelineNode(
        event: events[i],
        isFirst: i == 0,
        isLast: i == events.length - 1,
        onTap: () => onTap(events[i]),
      ),
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final HistoricalEvent event;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _TimelineNode({
    required this.event,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = event.category.color;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _NodeSpine(accent: accent, isFirst: isFirst, isLast: isLast),
          const SizedBox(width: 16),
          Expanded(child: _NodeCard(event: event, accent: accent, onTap: onTap)),
        ],
      ),
    );
  }
}

class _NodeSpine extends StatelessWidget {
  final Color accent;
  final bool isFirst;
  final bool isLast;

  const _NodeSpine({
    required this.accent,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Column(
        children: [
          if (!isFirst)
            Expanded(
              flex: 1,
              child: Center(
                child: Container(width: 2, color: AppTheme.outlineVariant),
              ),
            ),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.45),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          if (!isLast)
            Expanded(
              flex: 3,
              child: Center(
                child: Container(width: 2, color: AppTheme.outlineVariant),
              ),
            ),
        ],
      ),
    );
  }
}

class _NodeCard extends StatelessWidget {
  final HistoricalEvent event;
  final Color accent;
  final VoidCallback onTap;

  const _NodeCard({
    required this.event,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: 0.25), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                event.period,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: accent,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              event.location,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                color: AppTheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
