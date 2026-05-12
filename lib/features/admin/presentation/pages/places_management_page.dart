import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/app_cached_image.dart';
import 'package:timeexplorer/features/admin/presentation/manager/admin_provider.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';

class PlacesManagementPage extends StatefulWidget {
  const PlacesManagementPage({super.key});

  @override
  State<PlacesManagementPage> createState() => _PlacesManagementPageState();
}

class _PlacesManagementPageState extends State<PlacesManagementPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchPlaces();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Place> _filtered(List<Place> all) {
    if (_query.isEmpty) return all;
    final q = _query.toLowerCase();
    return all
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.location.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _confirmDelete(BuildContext ctx, AdminProvider provider, Place place) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Place', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete "${place.name}"? This action cannot be undone.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && ctx.mounted) {
      await provider.removePlace(place.id);
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('"${place.name}" deleted.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  static const _primary = AppTheme.primaryContainer;
  static const _dark = Color(0xFF0F172A);
  static const _bg = AppTheme.background;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _dark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Manage Places',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Auto-Fix Legacy Images',
            icon: const Icon(Icons.auto_fix_high),
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Starting image fix...')),
              );
              await context.read<AdminProvider>().fixLegacyPlaceImages();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image fix complete!')),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/places/form'),
        backgroundColor: _primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Place', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: Consumer<AdminProvider>(
        builder: (context, provider, _) {
          if (provider.isPlacesLoading && provider.places.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.placesError != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                  const SizedBox(height: 12),
                  Text('Error: ${provider.placesError}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: provider.fetchPlaces,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final filtered = _filtered(provider.places);

          return Column(
            children: [
              // Search bar
              Container(
                color: _dark,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  style: GoogleFonts.plusJakartaSans(color: _dark),
                  decoration: InputDecoration(
                    hintText: 'Search by name, category or location…',
                    hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.black38),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search_rounded, color: _primary),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.black38),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ),

              // Stats bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    Text(
                      '${filtered.length} place${filtered.length == 1 ? '' : 's'}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (provider.isPlacesLoading) ...[
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                  ],
                ),
              ),

              // List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.place_outlined, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 12),
                            Text(
                              _query.isEmpty ? 'No places yet. Tap + to add one.' : 'No results for "$_query".',
                              style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) => _PlaceTile(
                          place: filtered[i],
                          onEdit: () => context.push('/admin/places/form', extra: filtered[i]),
                          onDelete: () => _confirmDelete(context, provider, filtered[i]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlaceTile extends StatelessWidget {
  final Place place;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PlaceTile({required this.place, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cover image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: AppCachedImage(
              imageUrl: place.imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      _tag(place.category, Colors.blue),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          place.location,
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey[500]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        place.rating.toStringAsFixed(1),
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Actions
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryContainer),
                onPressed: onEdit,
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: onDelete,
                tooltip: 'Delete',
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }


  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
