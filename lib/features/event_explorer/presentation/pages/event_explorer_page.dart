import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/router/app_transitions.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/time_guide.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import '../widgets/locked_card_overlay.dart';
import '../widgets/memory_lock_overlay.dart';
import '../widgets/unlock_reveal_animation.dart';
import '../../data/datasources/event_static_data_source.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../data/services/seen_unlocks_store.dart';
import '../../domain/services/event_unlock_service.dart';
import '../../domain/usecases/get_all_events.dart';
import '../../domain/usecases/get_events_by_category.dart';
import '../../domain/usecases/search_events.dart';
import '../cubit/event_explorer_cubit.dart';
import '../cubit/event_explorer_state.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/event_card.dart';
import '../widgets/event_shimmer_card.dart';
import '../widgets/game_path_timeline.dart';
import 'event_detail_page.dart';
import 'timeline_map_page.dart';

class EventExplorerPage extends StatelessWidget {
  const EventExplorerPage({super.key});

  static EventExplorerCubit _buildCubit() {
    final ds = EventStaticDataSource();
    final repo = EventRepositoryImpl(ds);
    return EventExplorerCubit(
      getAll: GetAllEvents(repo),
      getByCategory: GetEventsByCategory(repo),
      search: SearchEvents(repo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _buildCubit()..loadAll(),
      child: const _EventExplorerView(),
    );
  }
}

class _EventExplorerView extends StatefulWidget {
  const _EventExplorerView();

  @override
  State<_EventExplorerView> createState() => _EventExplorerViewState();
}

class _EventExplorerViewState extends State<_EventExplorerView> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _timelineView = false;

  final SeenUnlocksStore _seenStore = SeenUnlocksStore();
  Set<String> _seenUnlocked = const {};
  bool _seenLoaded = false;
  bool _bootstrapped = false;

  @override
  void initState() {
    super.initState();
    _seenStore.load().then((set) {
      if (mounted) {
        setState(() {
          _seenUnlocked = set;
          _seenLoaded = true;
        });
      }
    });
  }

  /// On the very first run (empty seen-set), suppress animations for events
  /// that are already unlocked — only future unlocks should celebrate.
  void _bootstrapSeenIfNeeded(Iterable<String> currentlyUnlockedIds) {
    if (_bootstrapped || !_seenLoaded || _seenUnlocked.isNotEmpty) return;
    _bootstrapped = true;
    final initial = currentlyUnlockedIds.toSet();
    setState(() => _seenUnlocked = initial);
    for (final id in initial) {
      _seenStore.markSeen(id);
    }
  }

  void _markRevealed(String id) {
    if (_seenUnlocked.contains(id)) return;
    setState(() => _seenUnlocked = {..._seenUnlocked, id});
    _seenStore.markSeen(id);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) context.read<EventExplorerCubit>().searchByQuery(q);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<EventExplorerCubit>(),
              child: const TimelineMapPage(),
            ),
          ),
        ),
        backgroundColor: AppTheme.primaryContainer,
        tooltip: 'Timeline Map',
        child: const Icon(Icons.hub_rounded, color: Colors.white, size: 20),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                _Header(controller: _searchController, onSearch: _onSearch),
            BlocBuilder<EventExplorerCubit, EventExplorerState>(
              buildWhen: (prev, next) =>
                  next is EventExplorerLoaded || next is EventExplorerLoading,
              builder: (context, state) {
                final selected = state is EventExplorerLoaded
                    ? state.selectedCategory
                    : null;
                return Row(
                  children: [
                    Expanded(
                      child: CategoryFilterBar(
                        selected: selected,
                        onSelect: (cat) {
                          _searchController.clear();
                          context
                              .read<EventExplorerCubit>()
                              .filterByCategory(cat);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _ViewToggle(
                        isTimeline: _timelineView,
                        onToggle: () =>
                            setState(() => _timelineView = !_timelineView),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<EventExplorerCubit, EventExplorerState>(
                builder: (context, state) {
                  if (state is EventExplorerLoading ||
                      state is EventExplorerInitial) {
                    return const EventShimmerList();
                  }
                  if (state is EventExplorerError) {
                    return _ErrorView(message: state.message);
                  }
                  if (state is EventExplorerLoaded) {
                    if (state.events.isEmpty) {
                      return const _EmptyView();
                    }
                    final progress =
                        context.watch<GamificationProvider>().progress;
                    final allEvents = EventStaticDataSource.allEvents;

                    if (_seenLoaded && !_bootstrapped) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        final unlockedNow = allEvents
                            .where((e) => EventUnlockService.isUnlocked(
                                  event: e,
                                  allEvents: allEvents,
                                  progress: progress,
                                ))
                            .map((e) => e.id);
                        _bootstrapSeenIfNeeded(unlockedNow);
                      });
                    }

                    void openLocked(event) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => MemoryLockScreen(
                          event: event,
                          required: EventUnlockService.xpThreshold(
                              event, allEvents),
                          hint: EventUnlockService.unlockHint(
                            event: event,
                            allEvents: allEvents,
                          ),
                        ),
                      ));
                    }

                    void openDetail(event) {
                      Navigator.of(context).push(
                        AppTransitions.categoryReveal(
                          BlocProvider.value(
                            value: context.read<EventExplorerCubit>(),
                            child: EventDetailPage(event: event),
                          ),
                          event.category.color,
                        ),
                      );
                    }

                    if (_timelineView) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: GamePathTimeline(
                          events: state.events,
                          onTap: (event) {
                            if (!EventUnlockService.isUnlocked(
                              event: event,
                              allEvents: allEvents,
                              progress: progress,
                            )) {
                              openLocked(event);
                              return;
                            }
                            openDetail(event);
                          },
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 24),
                      cacheExtent: 600,
                      itemCount: state.events.length,
                      itemBuilder: (context, i) {
                        final event = state.events[i];
                        final unlocked = EventUnlockService.isUnlocked(
                          event: event,
                          allEvents: allEvents,
                          progress: progress,
                        );
                        final reqLvl = EventUnlockService.xpThreshold(
                            event, allEvents);
                        final card = EventCard(
                          key: ValueKey(event.id),
                          event: event,
                          isFavorite: state.isFavorite(event.id),
                          searchQuery: state.searchQuery,
                          onTap: () => unlocked
                              ? openDetail(event)
                              : openLocked(event),
                        );

                        Widget content = unlocked
                            ? card
                            : LockedCardOverlay(
                                requiredLevel: reqLvl,
                                accent: event.category.color,
                                child: card,
                              );

                        if (unlocked && !_seenUnlocked.contains(event.id)) {
                          content = UnlockRevealAnimation(
                            accent: event.category.color,
                            onShown: () => _markRevealed(event.id),
                            child: content,
                          );
                        }

                        return RepaintBoundary(child: content);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    ),
    Align(
      alignment: Alignment.bottomRight,
      child: TimeGuide(
        message: 'Tap any story to start exploring! 🗺️',
      ),
    ),
  ],
),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  final bool isTimeline;
  final VoidCallback onToggle;

  const _ViewToggle({required this.isTimeline, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isTimeline
              ? AppTheme.primaryContainer.withValues(alpha: 0.12)
              : AppTheme.surfaceLow,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Icon(
          isTimeline ? Icons.format_list_bulleted_rounded : Icons.timeline_rounded,
          color: isTimeline ? AppTheme.primaryContainer : AppTheme.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppTheme.onSurfaceVariant, size: 48),
          const SizedBox(height: 12),
          Text(message, style: AppTheme.bodySubtle, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => context.read<EventExplorerCubit>().loadAll(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded,
              color: AppTheme.onSurfaceVariant, size: 48),
          const SizedBox(height: 12),
          Text('No events found', style: AppTheme.bodySubtle),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  const _Header({required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spaceMD, AppTheme.spaceMD, AppTheme.spaceMD, AppTheme.spaceSM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (canPop)
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (canPop) const SizedBox(width: 8),
              const Text('⏳', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time Explorer', style: AppTheme.headlineLarge),
                  Text(
                    'Pick a story to discover!',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      color: AppTheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Search events, places, periods…',
              prefixIcon: const Icon(Icons.search_rounded,
                  color: AppTheme.onSurfaceVariant),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (_, v, __) => v.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          controller.clear();
                          onSearch('');
                        },
                      )
                    : const SizedBox.shrink(),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            style: GoogleFonts.beVietnamPro(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
