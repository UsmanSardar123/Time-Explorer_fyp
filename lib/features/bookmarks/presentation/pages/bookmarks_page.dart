import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/themed_loading.dart';
import 'package:timeexplorer/core/widgets/app_image_loader.dart';
import 'package:timeexplorer/core/widgets/dynamic_place_image.dart';
import 'package:timeexplorer/features/bookmarks/presentation/providers/bookmark_provider.dart';
import 'package:timeexplorer/features/event_explorer/core/category_image_helper.dart';
import 'package:timeexplorer/features/event_explorer/domain/entities/historical_event.dart';
import 'package:timeexplorer/features/event_explorer/presentation/pages/event_detail_page.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/explore/presentation/providers/place_provider.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarkProvider>().loadBookmarks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bp = context.watch<BookmarkProvider>();
    final catProvider = context.watch<PlaceProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Text(
                'My Collection',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurface,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: _ExploredSummaryCard(
                  totalPlaces: catProvider.places.length),
            ),
            _CollectionTabBar(controller: _tabController),
            const SizedBox(height: 4),
            Expanded(
              child: bp.isLoading
                  ? const ThemedLoading(context: 'categories')
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _PlacesTab(
                            places: bp.bookmarkedPlaces, provider: bp),
                        _EventsTab(events: bp.bookmarkedEvents),
                        _CharactersTab(
                            characters: bp.bookmarkedCharacters,
                            provider: bp),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab Bar ────────────────────────────────────────────────────────────────────

class _CollectionTabBar extends StatelessWidget {
  final TabController controller;
  const _CollectionTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppTheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12, fontWeight: FontWeight.w600),
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.onSurfaceVariant,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Places'),
          Tab(text: 'Events'),
          Tab(text: 'Figures'),
        ],
      ),
    );
  }
}

// ── Empty State ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.bookmark_border_rounded,
                size: 48, color: AppTheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          Text('Nothing saved yet',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface)),
          const SizedBox(height: 8),
          Text(message,
              style: GoogleFonts.beVietnamPro(
                  fontSize: 14, color: AppTheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

// ── Places Tab ─────────────────────────────────────────────────────────────────

class _PlacesTab extends StatelessWidget {
  final List<PlaceEntity> places;
  final BookmarkProvider provider;
  const _PlacesTab({required this.places, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const _EmptyState(message: 'Explore places and save your favorites.');
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      physics: const BouncingScrollPhysics(),
      itemCount: places.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) =>
          _PlaceCard(place: places[i], provider: provider),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final PlaceEntity place;
  final BookmarkProvider provider;
  const _PlaceCard({required this.place, required this.provider});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/place-details', extra: place),
      child: Container(
        height: 116,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: DynamicPlaceImage(
                query: place.name,
                placeId: place.id,
                fallbackUrl: (place.imageUrl).isNotEmpty ? place.imageUrl : null,
                width: 106,
                height: 116,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => provider.toggleBookmark(place),
                          child: const Icon(Icons.bookmark_remove_rounded,
                              color: AppTheme.primaryContainer, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        place.era ?? 'Ancient',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      place.description,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 12, color: AppTheme.onSurfaceVariant),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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

// ── Events Tab ─────────────────────────────────────────────────────────────────

class _EventsTab extends StatelessWidget {
  final List<HistoricalEvent> events;
  const _EventsTab({required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const _EmptyState(
          message: 'Bookmark events from the Events Explorer.');
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _EventCard(event: events[i]),
    );
  }
}

class _EventCard extends StatelessWidget {
  final HistoricalEvent event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => EventDetailPage(event: event)),
      ),
      child: Container(
        height: 116,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: event.category.color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: AppImageLoader(
                imageUrl: getCategoryImageAsset(event.category),
                category: event.category,
                heroTag: '${event.heroTag}_collection',
                width: 106,
                height: 116,
                borderRadius: 0,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      event.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: event.category.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        event.category.displayName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: event.category.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 10, color: AppTheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          event.period,
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 11, color: AppTheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 11, color: AppTheme.onSurfaceVariant),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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

// ── Characters Tab ─────────────────────────────────────────────────────────────

class _CharactersTab extends StatelessWidget {
  final List<Character> characters;
  final BookmarkProvider provider;
  const _CharactersTab(
      {required this.characters, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) {
      return const _EmptyState(
          message: 'Save historical figures from their profile pages.');
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      physics: const BouncingScrollPhysics(),
      itemCount: characters.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) =>
          _CharacterCard(character: characters[i], provider: provider),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final Character character;
  final BookmarkProvider provider;
  const _CharacterCard(
      {required this.character, required this.provider});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push('/personality-detail', extra: character),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ClipOval(
              child: character.imageUrl.isEmpty
                  ? Container(
                      width: 56,
                      height: 56,
                      color: AppTheme.surfaceLow,
                      child: Icon(character.category.icon,
                          color: AppTheme.primaryContainer, size: 28),
                    )
                  : CachedNetworkImage(
                      imageUrl: character.imageUrl,
                      httpHeaders: const {
                        'User-Agent': 'TimeExplorer/1.0 (Flutter)'
                      },
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                          width: 56,
                          height: 56,
                          color: AppTheme.surfaceLow),
                      errorWidget: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: AppTheme.surfaceLow,
                        child: Icon(character.category.icon,
                            color: AppTheme.primaryContainer, size: 28),
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    character.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    character.title.isNotEmpty
                        ? character.title
                        : character.category.displayName,
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 12, color: AppTheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    character.era,
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        color: AppTheme.outlineVariant,
                        fontStyle: FontStyle.italic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => provider.toggleCharacterBookmark(character),
              icon: const Icon(Icons.bookmark_remove_rounded,
                  color: AppTheme.primaryContainer, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Explored Summary Card ──────────────────────────────────────────────────────

class _ExploredSummaryCard extends StatelessWidget {
  final int totalPlaces;
  const _ExploredSummaryCard({required this.totalPlaces});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('progress')
          .doc('places')
          .snapshots(),
      builder: (context, snap) {
        final data = snap.data?.data() as Map<String, dynamic>?;
        final explored = (data?['totalExplored'] as int?) ?? 0;
        final total = totalPlaces > 0 ? totalPlaces : 1;
        final pct = (explored / total).clamp(0.0, 1.0);

        return GestureDetector(
          onTap: () => context.push('/progress'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.primaryContainer.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.explore_rounded,
                      color: AppTheme.primaryContainer, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$explored / $totalPlaces explored',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(pct * 100).toInt()}%',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 5,
                          backgroundColor: AppTheme.surfaceHigh,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryContainer),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.chevron_right_rounded,
                    color: AppTheme.onSurfaceVariant, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}
