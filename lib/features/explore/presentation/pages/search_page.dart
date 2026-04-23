import 'package:timeexplorer/core/widgets/dynamic_place_image.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/personalities/data/datasources/character_local_data_source.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _primary = AppTheme.primaryContainer;
  static const _bg = AppTheme.background;
  static const _surfaceLow = AppTheme.surfaceLow;
  static const _textDark = AppTheme.onSurface;
  static const _textMuted = AppTheme.onSurfaceVariant;
  static const _textHint = AppTheme.outlineVariant;

  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _dataSource = CharacterLocalDataSource();

  List<PlaceEntity> _placeResults = [];
  List<Character> _characterResults = [];
  bool _isLoading = false;
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      setState(() { _placeResults = []; _characterResults = []; _query = ''; });
      return;
    }

    setState(() { _isLoading = true; _query = q; });

    final lower = q.toLowerCase();

    // Character search is local — instant.
    final chars = _dataSource.getAll().where((c) =>
        c.name.toLowerCase().contains(lower) ||
        c.category.displayName.toLowerCase().contains(lower) ||
        c.title.toLowerCase().contains(lower)).toList();

    // Places search runs against Firestore.
    List<PlaceEntity> places = [];
    try {
      final snap = await _firestore.collection('places').get();
      places = snap.docs
          .map((doc) {
            final json = doc.data();
            return PlaceEntity(
              id: doc.id,
              name: json['name'] ?? '',
              description: json['description'] ?? '',
              imageUrl: json['imageUrl'] ?? '',
              category: json['category'] ?? '',
              rating: (json['rating'] ?? 0.0).toDouble(),
              location: json['location'] ?? '',
              era: json['era'] ?? json['category'] ?? '',
            );
          })
          .where((p) =>
              p.name.toLowerCase().contains(lower) ||
              p.location.toLowerCase().contains(lower) ||
              p.category.toLowerCase().contains(lower))
          .toList();
    } catch (e) {
      debugPrint('[Search] Firestore error: $e');
    }

    if (mounted) {
      setState(() {
        _characterResults = chars;
        _placeResults = places;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark),
          onPressed: () => context.pop(),
        ),
        title: Container(
          decoration: BoxDecoration(
            color: _surfaceLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            style: GoogleFonts.beVietnamPro(color: _textDark, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: 'Search places or historical figures…',
              hintStyle: GoogleFonts.beVietnamPro(color: _textHint, fontSize: 14),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search_rounded, color: _primary),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onChanged: _search,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: _primary));
    }

    if (_query.isEmpty) {
      return _buildEmptyState(
        Icons.history_toggle_off_rounded,
        'Where shall we travel?',
        'Search for historical sites or legendary figures.',
      );
    }

    final hasResults = _placeResults.isNotEmpty || _characterResults.isNotEmpty;
    if (!hasResults) {
      return _buildEmptyState(
        Icons.search_off_rounded,
        'No matches found',
        'Try a different name, place, or era.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        if (_characterResults.isNotEmpty) ...[
          _sectionHeader(Icons.person_rounded, 'Historical Figures', _characterResults.length),
          const SizedBox(height: 10),
          ..._characterResults.map(_buildCharacterTile),
          const SizedBox(height: 24),
        ],
        if (_placeResults.isNotEmpty) ...[
          _sectionHeader(Icons.place_rounded, 'Historical Places', _placeResults.length),
          const SizedBox(height: 10),
          ..._placeResults.map(_buildPlaceTile),
        ],
      ],
    );
  }

  Widget _sectionHeader(IconData icon, String label, int count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _primary),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14, fontWeight: FontWeight.w700, color: _textDark)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('$count',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11, fontWeight: FontWeight.w700, color: _primary)),
        ),
      ],
    );
  }

  Widget _buildCharacterTile(Character character) {
    return GestureDetector(
      onTap: () => context.push('/personality-detail', extra: character),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
              child: SizedBox(
                width: 72,
                height: 72,
                child: DynamicPlaceImage(
                  query: character.name,
                  fallbackUrl: character.imageUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(character.name,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 14, fontWeight: FontWeight.w700, color: _textDark)),
                    const SizedBox(height: 2),
                    Text(character.title,
                        style: GoogleFonts.beVietnamPro(fontSize: 12, color: _textMuted),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(character.category.displayName,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 10, fontWeight: FontWeight.w700, color: _primary)),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: _textHint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceTile(PlaceEntity place) {
    return GestureDetector(
      onTap: () => context.push('/place-details', extra: place),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
              child: SizedBox(
                width: 72,
                height: 72,
                child: DynamicPlaceImage(
                  query: place.name,
                  fallbackUrl: place.imageUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 14, fontWeight: FontWeight.w700, color: _textDark),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: _textHint),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(place.location,
                              style: GoogleFonts.beVietnamPro(fontSize: 12, color: _textMuted),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    if (place.era != null && place.era!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEB246).withOpacity(0.20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(place.era!,
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 10, fontWeight: FontWeight.w700,
                                color: const Color(0xFF6F4600))),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: _textHint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: _surfaceLow, shape: BoxShape.circle),
            child: Icon(icon, size: 64, color: _primary.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          Text(title,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 20, fontWeight: FontWeight.w800, color: _textDark)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: _textMuted)),
          ),
        ],
      ),
    );
  }
}
