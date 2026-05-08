import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/router/app_transitions.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import '../../domain/entities/event_category.dart';
import '../cubit/event_explorer_cubit.dart';
import '../cubit/event_explorer_state.dart';
import 'event_detail_page.dart';

class TimelineMapPage extends StatefulWidget {
  const TimelineMapPage({super.key});

  @override
  State<TimelineMapPage> createState() => _TimelineMapPageState();
}

class _TimelineMapPageState extends State<TimelineMapPage>
    with SingleTickerProviderStateMixin {
  EventCategory? _active;
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0B1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0B1A),
        elevation: 0,
        title: Text(
          'Timeline Map',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, __) => CustomPaint(
                painter: _MapPainter(
                  active: _active,
                  pulse: _pulseCtrl.value,
                ),
                child: _NodeOverlay(
                  active: _active,
                  onSelect: (cat) => setState(() =>
                      _active = (_active == cat) ? null : cat),
                ),
              ),
            ),
          ),
          if (_active != null)
            _EventList(
              category: _active!,
              cubit: context.read<EventExplorerCubit>(),
            ),
        ],
      ),
    );
  }
}

// ── Connection line painter ──────────────────────────────────────────────────

class _MapPainter extends CustomPainter {
  final EventCategory? active;
  final double pulse;

  const _MapPainter({required this.active, required this.pulse});

  static List<Offset> _positions(Size size) {
    final cats = EventCategory.values;
    final cx = size.width / 2;
    final cy = size.height / 2;
    return List.generate(cats.length, (i) {
      final angle = (i / cats.length) * math.pi * 2 - math.pi / 2;
      final r = math.min(cx, cy) * 0.62;
      return Offset(cx + r * math.cos(angle), cy + r * math.sin(angle));
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final positions = _positions(size);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.10);

    for (int i = 0; i < positions.length; i++) {
      canvas.drawLine(
        positions[i],
        positions[(i + 1) % positions.length],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_MapPainter old) =>
      old.active != active || old.pulse != pulse;
}

// ── Tappable node overlay ────────────────────────────────────────────────────

class _NodeOverlay extends StatelessWidget {
  final EventCategory? active;
  final ValueChanged<EventCategory> onSelect;

  const _NodeOverlay({required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final cats = EventCategory.values;
    return LayoutBuilder(
      builder: (_, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final cx = size.width / 2;
        final cy = size.height / 2;
        final r = math.min(cx, cy) * 0.62;

        return Stack(
          children: [
            // Center hub
            Positioned(
              left: cx - 36,
              top: cy - 36,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryContainer.withValues(alpha: 0.5),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.timeline_rounded,
                    color: Colors.white, size: 32),
              ),
            ),
            ...List.generate(cats.length, (i) {
              final angle = (i / cats.length) * math.pi * 2 - math.pi / 2;
              final x = cx + r * math.cos(angle);
              final y = cy + r * math.sin(angle);
              final cat = cats[i];
              final isActive = active == cat;
              return Positioned(
                left: x - 36,
                top: y - 36,
                child: _EraNode(
                  category: cat,
                  isActive: isActive,
                  onTap: () => onSelect(cat),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _EraNode extends StatelessWidget {
  final EventCategory category;
  final bool isActive;
  final VoidCallback onTap;

  const _EraNode({
    required this.category,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: isActive ? 80 : 68,
        height: isActive ? 80 : 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? category.color : category.color.withValues(alpha: 0.25),
          border: Border.all(
            color: category.color,
            width: isActive ? 3 : 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: category.color.withValues(alpha: 0.6),
                    blurRadius: 20,
                    spreadRadius: 4,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, color: Colors.white, size: 20),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                category.displayName.split(' ').first,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Event list panel ─────────────────────────────────────────────────────────

class _EventList extends StatelessWidget {
  final EventCategory category;
  final EventExplorerCubit cubit;

  const _EventList({required this.category, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final events = cubit.state is EventExplorerLoaded
        ? (cubit.state as EventExplorerLoaded)
            .events
            .where((e) => e.category == category)
            .take(4)
            .toList()
        : <dynamic>[];

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF14132A),
        border: Border(
          top: BorderSide(color: category.color.withValues(alpha: 0.4), width: 1),
        ),
      ),
      child: events.isEmpty
          ? Center(
              child: Text(
                'No events in this category',
                style: GoogleFonts.beVietnamPro(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: events.length,
              itemBuilder: (context, i) {
                final event = events[i];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    AppTransitions.categoryReveal(
                      BlocProvider.value(
                        value: cubit,
                        child: EventDetailPage(event: event),
                      ),
                      category.color,
                    ),
                  ),
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: category.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: category.color.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.period,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            color: category.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
