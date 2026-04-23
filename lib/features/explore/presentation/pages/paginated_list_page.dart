import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/dynamic_place_image.dart';
import 'package:timeexplorer/features/explore/domain/entities/personality_entity.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/explore/presentation/widgets/place_card.dart';

enum ListType { places, personalities }

class PaginatedListPage extends StatefulWidget {
  final ListType type;
  final String title;

  const PaginatedListPage({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  State<PaginatedListPage> createState() => _PaginatedListPageState();
}

class _PaginatedListPageState extends State<PaginatedListPage> {
  // ── Design Tokens ─────────────────────────────────────────────────────────
  static const _primary = AppTheme.primaryContainer;
  static const _bg = AppTheme.background;
  static const _surfaceLow = AppTheme.surfaceLow;
  static const _textDark = AppTheme.onSurface;
  static const _textMuted = AppTheme.onSurfaceVariant;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const int _limit = 10;
  
  List<dynamic> _items = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;
  List<dynamic> _fullItems = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final collection = widget.type == ListType.places ? 'places' : 'personalities';
      final querySnapshot = await _firestore.collection(collection).get();
      final mappedItems = querySnapshot.docs.map((doc) {
        final json = doc.data();
        if (widget.type == ListType.places) {
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
        } else {
          return PersonalityEntity(
            id: doc.id,
            name: json['name'] ?? '',
            description: json['description'] ?? '',
            imageUrl: json['imageUrl'] ?? '',
            era: json['era'] ?? '',
          );
        }
      }).toList();

      if (mounted) {
        setState(() {
          _totalPages = (mappedItems.length / _limit).ceil();
          if (_totalPages == 0) _totalPages = 1;
          _fullItems = mappedItems;
          _loadPage(1);
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _loadPage(int page) {
    final startIndex = (page - 1) * _limit;
    if (startIndex < _fullItems.length) {
      final endIndex = (startIndex + _limit < _fullItems.length) ? startIndex + _limit : _fullItems.length;
      setState(() {
        _items = _fullItems.sublist(startIndex, endIndex);
        _currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text(widget.title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: _textDark)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: _primary))
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      if (widget.type == ListType.places) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: SizedBox(height: 260, child: PlaceCard(place: item as PlaceEntity)),
                        );
                      } else {
                        final p = item as PersonalityEntity;
                        return _buildPersonalityTile(p);
                      }
                    },
                  ),
          ),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildPersonalityTile(PersonalityEntity p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _textDark.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => context.push('/personality-details', extra: p),
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _primary, width: 2),
          ),
          child: ClipOval(
            child: DynamicPlaceImage(
              query: p.name,
              fallbackUrl: p.imageUrl.isNotEmpty ? p.imageUrl : null,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(p.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16)),
        subtitle: Text(p.era, style: GoogleFonts.beVietnamPro(color: _primary, fontWeight: FontWeight.bold, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: _primary, size: 16),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, color: _primary),
            onPressed: _currentPage > 1 ? () => _loadPage(_currentPage - 1) : null,
          ),
          const SizedBox(width: 8),
          ...List.generate(_totalPages, (index) {
            final page = index + 1;
            final isCurrent = _currentPage == page;
            return GestureDetector(
              onTap: () => _loadPage(page),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isCurrent ? _primary : _surfaceLow,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$page',
                    style: GoogleFonts.plusJakartaSans(
                      color: isCurrent ? Colors.white : _textDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, color: _primary),
            onPressed: _currentPage < _totalPages ? () => _loadPage(_currentPage + 1) : null,
          ),
        ],
      ),
    );
  }
}
