import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/app_image_loader.dart';
import 'package:timeexplorer/core/widgets/time_guide.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import '../../core/category_image_helper.dart';
import '../../core/wikimedia_headers.dart';
import '../../data/datasources/event_static_data_source.dart';
import '../../domain/entities/historical_event.dart';
import '../cubit/event_explorer_cubit.dart';
import '../cubit/event_explorer_state.dart';
import '../widgets/did_you_know_cards.dart';
import '../widgets/event_mini_quiz.dart';
import '../widgets/event_timeline_tile.dart';
import '../../data/datasources/event_quiz_catalog.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'event_expert_chat_page.dart';
import '../widgets/narrator_sheet.dart';
import 'package:timeexplorer/core/services/ambient_audio_service.dart';
import 'package:timeexplorer/views/storyboard_card.dart';

class EventDetailPage extends StatefulWidget {
  final HistoricalEvent event;

  const EventDetailPage({super.key, required this.event});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _ambientOn = AmbientAudioService.instance.enabled;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        context
            .read<GamificationProvider>()
            .recordEventCompleted(widget.event.id);
      } catch (_) {}
    });
  }

  void _toggleAmbient() async {
    await AmbientAudioService.instance.toggle();
    if (mounted) setState(() => _ambientOn = AmbientAudioService.instance.enabled);
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final accent = event.category.color;
    final heroHeight = MediaQuery.of(context).size.height * 0.4;
    final hasQuiz = EventQuizCatalog.hasQuiz(event.id);
    final guideMessage = hasQuiz
        ? 'Try the quiz to earn Time Energy! 🧠'
        : 'Swipe the cards to discover fun facts!';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollView(
              slivers: _buildSlivers(event, accent, heroHeight),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TimeGuide(message: guideMessage),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSlivers(
      HistoricalEvent event, Color accent, double heroHeight) {
    return [
          // ── Hero Header ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: heroHeight,
            pinned: true,
            stretch: true,
            backgroundColor: AppTheme.background,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(
                  _ambientOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  color: Colors.white,
                ),
                onPressed: _toggleAmbient,
                tooltip: 'Ambient Sound',
              ),
              IconButton(
                icon: const Icon(Icons.share_rounded, color: Colors.white),
                onPressed: () => _shareEvent(event),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
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
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                          Colors.black87,
                        ],
                        stops: [0.6, 0.85, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            event.category.displayName.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.title,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Event Info ───────────────────────────────────────────────────────
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(AppTheme.spaceMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ActionRow(event: event, accent: accent),
                    const SizedBox(height: AppTheme.spaceLG),
                    _MetaRow(event: event),
                    const SizedBox(height: AppTheme.spaceLG),
                    DidYouKnowCards(
                      facts: event.keyFacts,
                      fullText: event.description,
                      accent: accent,
                    ),
                    if (EventQuizCatalog.hasQuiz(event.id)) ...[
                      const SizedBox(height: AppTheme.spaceLG),
                      EventMiniQuiz(eventId: event.id, accent: accent),
                    ],
                  ],
                ),
              ),
            ]),
          ),

          // ── Watch Documentaries ──────────────────────────────────────────────
          _WatchDocumentariesSection(event: event),

          // ── Timeline ────────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMD),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionHeader(label: 'HISTORICAL TIMELINE', accent: accent),
                const SizedBox(height: 16),
                ...event.timeline.asMap().entries.map(
                      (e) => EventTimelineTile(
                        point: e.value,
                        isFirst: e.key == 0,
                        isLast: e.key == event.timeline.length - 1,
                        accentColor: accent,
                      ),
                    ),
                const SizedBox(height: AppTheme.spaceXL),
              ]),
            ),
          ),

          _InteractiveMapSection(event: event),
          _VideoBriefingSection(event: event),

          // ── Storyboard Section ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(label: 'VISUAL STORYBOARD', accent: accent),
                  const SizedBox(height: 16),
                  StoryboardCard(storyboardId: 'event_${event.id}'),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Context & Related ────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                AppTheme.spaceMD, 0, AppTheme.spaceMD, AppTheme.spaceXL),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _TimelineContextSection(currentEvent: event, accent: accent),
                _RelatedEvents(currentEvent: event, accent: accent),
                const SizedBox(height: 40),
              ]),
            ),
          ),
    ];
  }

  void _shareEvent(HistoricalEvent event) {
    Share.share(
      '${event.title} (${event.period})\n\n'
      '${event.description.length > 160 ? "${event.description.substring(0, 160)}…" : event.description}'
      '\n\nDiscover more on Time Explorer',
      subject: event.title,
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color accent;
  const _SectionHeader({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ── Watch Documentaries ────────────────────────────────────────────────────────

class _WatchDocumentariesSection extends StatelessWidget {
  final HistoricalEvent event;
  const _WatchDocumentariesSection({required this.event});

  Future<void> _openDocumentaries() async {
    final query =
        Uri.encodeComponent('${event.title} full documentary history');
    final url =
        Uri.parse('https://www.youtube.com/results?search_query=$query');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = event.category.color;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppTheme.spaceMD, 0, AppTheme.spaceMD, AppTheme.spaceLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(label: 'DOCUMENTARY', accent: accent),
            const SizedBox(height: 12),
            InkWell(
              onTap: _openDocumentaries,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spaceMD),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF0000).withValues(alpha: 0.1),
                      const Color(0xFFFF0000).withValues(alpha: 0.04),
                    ],
                  ),
                  border: Border.all(
                      color: const Color(0xFFFF0000).withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.play_circle_filled_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Watch Documentary on YouTube',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '"${event.title}" — full history documentary',
                            style: AppTheme.bodySubtle.copyWith(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.open_in_new_rounded,
                        color: AppTheme.onSurfaceVariant, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Meta Row ───────────────────────────────────────────────────────────────────

class _MetaRow extends StatelessWidget {
  final HistoricalEvent event;
  const _MetaRow({required this.event});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _MetaItem(
            icon: Icons.calendar_today_rounded,
            label: event.period,
            subtitle: 'Period',
          ),
          const SizedBox(width: 24),
          _MetaItem(
            icon: Icons.location_on_rounded,
            label: event.location,
            subtitle: 'Location',
          ),
          const SizedBox(width: 24),
          _MetaItem(
            icon: Icons.auto_awesome_rounded,
            label: '${event.importanceLevel}/5',
            subtitle: 'Importance',
            iconColor: Colors.amber,
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color? iconColor;

  const _MetaItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? AppTheme.primary).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: iconColor ?? AppTheme.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: AppTheme.bodySubtle.copyWith(fontSize: 11),
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Action Row ─────────────────────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  final HistoricalEvent event;
  final Color accent;
  const _ActionRow({required this.event, required this.accent});

  @override
  Widget build(BuildContext context) {
    EventExplorerCubit? cubit;
    try {
      cubit = context.read<EventExplorerCubit>();
    } catch (_) {}

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => EventExpertChatPage(event: event),
                )),
                icon: const Icon(Icons.school_rounded, size: 20),
                label: const Text('Ask an Expert'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (cubit != null)
              BlocBuilder<EventExplorerCubit, EventExplorerState>(
                bloc: cubit,
                builder: (context, state) {
                  final isFav = state is EventExplorerLoaded &&
                      state.isFavorite(event.id);
                  return IconButton.filledTonal(
                    onPressed: () => cubit?.toggleFavorite(event.id),
                    icon: Icon(
                      isFav
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isFav ? Colors.amber : null,
                    ),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      minimumSize: const Size(56, 56),
                    ),
                  );
                },
              ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => NarratorSheet.show(
              context,
              text: event.description.replaceAll(RegExp(r'[#*_`]'), '').trim(),
              accentColor: accent,
              title: event.title,
            ),
            icon: Icon(Icons.volume_up_rounded, color: accent, size: 20),
            label: Text(
              'Read Aloud',
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: accent.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Timeline Context ───────────────────────────────────────────────────────────

class _TimelineContextSection extends StatelessWidget {
  final HistoricalEvent currentEvent;
  final Color accent;

  const _TimelineContextSection({required this.currentEvent, required this.accent});

  @override
  Widget build(BuildContext context) {
    EventExplorerCubit? cubit;
    try { cubit = context.read<EventExplorerCubit>(); } catch (_) {}

    final before = EventStaticDataSource.contextBefore(currentEvent);
    final after = EventStaticDataSource.contextAfter(currentEvent);
    final parallel = EventStaticDataSource.contextParallel(currentEvent);

    if (before.isEmpty && after.isEmpty && parallel.isEmpty) return const SizedBox.shrink();

    void goTo(HistoricalEvent e) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => cubit != null
            ? BlocProvider.value(value: cubit, child: EventDetailPage(event: e))
            : EventDetailPage(event: e),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(label: 'TIMELINE CONTEXT', accent: accent),
        const SizedBox(height: 16),
        if (before.isNotEmpty)
          _ContextRow(label: 'Before', icon: Icons.history_rounded, events: before, onTap: goTo),
        if (parallel.isNotEmpty)
          _ContextRow(label: 'Parallel', icon: Icons.linear_scale_rounded, events: parallel, onTap: goTo),
        if (after.isNotEmpty)
          _ContextRow(label: 'After', icon: Icons.update_rounded, events: after, onTap: goTo),
        const SizedBox(height: AppTheme.spaceXL),
      ],
    );
  }
}

class _ContextRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<HistoricalEvent> events;
  final void Function(HistoricalEvent) onTap;

  const _ContextRow({required this.label, required this.icon, required this.events, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 13, color: AppTheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(label.toUpperCase(), style: GoogleFonts.plusJakartaSans(
            fontSize: 10, fontWeight: FontWeight.w700,
            color: AppTheme.onSurfaceVariant, letterSpacing: 0.8,
          )),
        ]),
        const SizedBox(height: 8),
        SizedBox(
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => _ContextChip(
              event: events[i],
              onTap: () => onTap(events[i]),
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

class _ContextChip extends StatelessWidget {
  final HistoricalEvent event;
  final VoidCallback onTap;

  const _ContextChip({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = event.category.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: c.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
              child: Text(event.period, style: GoogleFonts.beVietnamPro(
                fontSize: 9, color: c, fontWeight: FontWeight.w600,
              ), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(height: 6),
            Text(event.title, style: GoogleFonts.plusJakartaSans(
              fontSize: 12, fontWeight: FontWeight.w700,
              color: AppTheme.onSurface, height: 1.3,
            ), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ── Related Events ─────────────────────────────────────────────────────────────

class _RelatedEvents extends StatelessWidget {
  final HistoricalEvent currentEvent;
  final Color accent;
  const _RelatedEvents({required this.currentEvent, required this.accent});

  @override
  Widget build(BuildContext context) {
    final related = EventStaticDataSource.relatedTo(currentEvent, limit: 3);
    if (related.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(label: 'RELATED DISCOVERIES', accent: accent),
        const SizedBox(height: 16),
        ...related.map(
          (e) => _RelatedEventTile(
            event: e,
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<EventExplorerCubit>(),
                  child: EventDetailPage(event: e),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RelatedEventTile extends StatelessWidget {
  final HistoricalEvent event;
  final VoidCallback onTap;
  const _RelatedEventTile({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: AppTheme.cardBox(border: true),
          child: Row(
            children: [
              AppImageLoader(
                imageUrl: getCategoryImageAsset(event.category),
                category: event.category,
                headers: kWikimediaHeaders,
                heroTag: '${event.heroTag}_related',
                width: 64,
                height: 64,
                borderRadius: 12,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.period,
                      style: AppTheme.bodySubtle.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Interactive Map ────────────────────────────────────────────────────────────

class _InteractiveMapSection extends StatelessWidget {
  final HistoricalEvent event;
  const _InteractiveMapSection({required this.event});

  @override
  Widget build(BuildContext context) {
    if (event.latitude == null || event.longitude == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    try {
      return SliverToBoxAdapter(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppTheme.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(
                  label: 'LOCATION MAP', accent: event.category.color),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 200,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter:
                          LatLng(event.latitude!, event.longitude!),
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.timeexplorer',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point:
                                LatLng(event.latitude!, event.longitude!),
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.location_on,
                              color: event.category.color,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceXL),
            ],
          ),
        ),
      );
    } catch (e) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceMD, vertical: 16),
          child: Chip(
            label: const Text('Map Preview Unavailable'),
            backgroundColor: Colors.grey[200],
            avatar: const Icon(Icons.map_outlined),
          ),
        ),
      );
    }
  }
}

// ── Video Briefing ─────────────────────────────────────────────────────────────

class _VideoBriefingSection extends StatefulWidget {
  final HistoricalEvent event;
  const _VideoBriefingSection({required this.event});

  @override
  State<_VideoBriefingSection> createState() => _VideoBriefingSectionState();
}

class _VideoBriefingSectionState extends State<_VideoBriefingSection> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.event.youtubeUrl != null) {
      final videoId =
          YoutubePlayer.convertUrlToId(widget.event.youtubeUrl!);
      if (videoId != null) {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
        );
      }
    }
  }

  @override
  void deactivate() {
    _controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    try {
      return SliverToBoxAdapter(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppTheme.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(
                  label: 'VIDEO BRIEFING',
                  accent: widget.event.category.color),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: widget.event.category.color,
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                    FullScreenButton(),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spaceXL),
            ],
          ),
        ),
      );
    } catch (e) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceMD, vertical: 16),
          child: Chip(
            label: const Text('Video Unavailable'),
            backgroundColor: Colors.grey[200],
            avatar: const Icon(Icons.video_library_outlined),
          ),
        ),
      );
    }
  }
}
