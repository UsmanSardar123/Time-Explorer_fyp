import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import '../../data/datasources/event_static_data_source.dart';
import '../../domain/entities/historical_event.dart';
import '../../domain/services/event_unlock_service.dart';

/// A horizontal "game path" of glowing nodes for events.
/// Highlights the next-to-play (focus) and the most recently completed.
class GamePathTimeline extends StatelessWidget {
  final List<HistoricalEvent> events;
  final void Function(HistoricalEvent) onTap;

  const GamePathTimeline({
    super.key,
    required this.events,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();
    return Consumer<GamificationProvider>(
      builder: (context, gam, _) {
        final progress = gam.progress;
        final allEvents = EventStaticDataSource.allEvents;

        final completed = progress.completedEventIds.toSet();
        final focusIndex = _findFocus(events, completed);

        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: events.length,
            itemBuilder: (context, i) {
              final event = events[i];
              final unlocked = EventUnlockService.isUnlocked(
                event: event,
                allEvents: allEvents,
                progress: progress,
              );
              final isCompleted = completed.contains(event.id);
              final isFocus = i == focusIndex;
              return _PathNode(
                event: event,
                index: i,
                isFirst: i == 0,
                isLast: i == events.length - 1,
                unlocked: unlocked,
                completed: isCompleted,
                focus: isFocus,
                onTap: () => onTap(event),
              );
            },
          ),
        );
      },
    );
  }

  int _findFocus(List<HistoricalEvent> events, Set<String> completed) {
    for (var i = 0; i < events.length; i++) {
      if (!completed.contains(events[i].id)) return i;
    }
    return events.length - 1;
  }
}

class _PathNode extends StatefulWidget {
  final HistoricalEvent event;
  final int index;
  final bool isFirst;
  final bool isLast;
  final bool unlocked;
  final bool completed;
  final bool focus;
  final VoidCallback onTap;

  const _PathNode({
    required this.event,
    required this.index,
    required this.isFirst,
    required this.isLast,
    required this.unlocked,
    required this.completed,
    required this.focus,
    required this.onTap,
  });

  @override
  State<_PathNode> createState() => _PathNodeState();
}

class _PathNodeState extends State<_PathNode>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulse;

  @override
  void initState() {
    super.initState();
    if (widget.focus) _startPulse();
  }

  @override
  void didUpdateWidget(_PathNode old) {
    super.didUpdateWidget(old);
    if (widget.focus && !old.focus) {
      _startPulse();
    } else if (!widget.focus && old.focus) {
      _pulse?.stop();
      _pulse?.dispose();
      _pulse = null;
    }
  }

  void _startPulse() {
    _pulse?.dispose();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.event.category.color;
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          SizedBox(
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _Connector(
                  isFirst: widget.isFirst,
                  isLast: widget.isLast,
                  active: widget.completed,
                  accent: accent,
                ),
                _NodeButton(
                  accent: accent,
                  unlocked: widget.unlocked,
                  completed: widget.completed,
                  focus: widget.focus,
                  pulse: _pulse,
                  onTap: widget.onTap,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              widget.event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: widget.unlocked
                    ? AppTheme.onSurface
                    : AppTheme.onSurfaceVariant,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.event.period,
            style: GoogleFonts.beVietnamPro(
              fontSize: 10,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          if (widget.focus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'NEXT',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool active;
  final Color accent;

  const _Connector({
    required this.isFirst,
    required this.isLast,
    required this.active,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 46),
              decoration: BoxDecoration(
                color: !isFirst
                    ? (active ? accent : AppTheme.outlineVariant)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 64),
          Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 46),
              decoration: BoxDecoration(
                color: !isLast
                    ? (active ? accent : AppTheme.outlineVariant)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NodeButton extends StatelessWidget {
  final Color accent;
  final bool unlocked;
  final bool completed;
  final bool focus;
  final AnimationController? pulse;
  final VoidCallback onTap;

  const _NodeButton({
    required this.accent,
    required this.unlocked,
    required this.completed,
    required this.focus,
    required this.pulse,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final node = GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: unlocked
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent.withValues(alpha: completed ? 1.0 : 0.85),
                    accent.withValues(alpha: completed ? 0.75 : 0.45),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.surfaceLow,
                    AppTheme.surfaceLow.withValues(alpha: 0.5),
                  ],
                ),
          border: Border.all(
            color: unlocked ? accent : AppTheme.outlineVariant,
            width: 2,
          ),
          boxShadow: unlocked
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.45),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: completed
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 28)
              : unlocked
                  ? Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 28)
                  : Icon(Icons.lock_rounded,
                      color: AppTheme.onSurfaceVariant, size: 22),
        ),
      ),
    );

    if (pulse == null) return node;
    return AnimatedBuilder(
      animation: pulse!,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 64 + (pulse!.value * 22),
              height: 64 + (pulse!.value * 22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.18 * (1 - pulse!.value)),
              ),
            ),
            child!,
          ],
        );
      },
      child: node,
    );
  }
}
