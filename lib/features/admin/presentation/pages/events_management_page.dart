import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/app_cached_image.dart';
import 'package:timeexplorer/features/admin/presentation/manager/admin_provider.dart';
import 'package:timeexplorer/features/event_explorer/domain/entities/historical_event.dart';

class EventsManagementPage extends StatefulWidget {
  const EventsManagementPage({super.key});

  @override
  State<EventsManagementPage> createState() => _EventsManagementPageState();
}

class _EventsManagementPageState extends State<EventsManagementPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchEvents();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<HistoricalEvent> _filtered(List<HistoricalEvent> all) {
    if (_query.isEmpty) return all;
    final q = _query.toLowerCase();
    return all
        .where((e) =>
            e.title.toLowerCase().contains(q) ||
            e.category.displayName.toLowerCase().contains(q) ||
            e.location.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _confirmDelete(BuildContext ctx, AdminProvider provider, HistoricalEvent event) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Event', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete "${event.title}"? This action cannot be undone.',
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
      await provider.removeEvent(event.id);
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('"${event.title}" deleted.'),
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
          'Manage Events',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/events/form'),
        backgroundColor: _primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Event', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: Consumer<AdminProvider>(
        builder: (context, provider, _) {
          if (provider.isEventsLoading && provider.events.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.eventsError != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                  const SizedBox(height: 12),
                  Text('Error: ${provider.eventsError}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: provider.fetchEvents,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final filtered = _filtered(provider.events);

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
                    hintText: 'Search by title, category or location…',
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
                      '${filtered.length} event${filtered.length == 1 ? '' : 's'}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (provider.isEventsLoading) ...[
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
                            Icon(Icons.event_note_outlined, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 12),
                            Text(
                              _query.isEmpty ? 'No events yet. Tap + to add one.' : 'No results for "$_query".',
                              style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) => _EventTile(
                          event: filtered[i],
                          onEdit: () => context.push('/admin/events/form', extra: filtered[i]),
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

class _EventTile extends StatelessWidget {
  final HistoricalEvent event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EventTile({required this.event, required this.onEdit, required this.onDelete});

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
              imageUrl: event.heroImageUrl,
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
                    event.title,
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
                      _tag(event.category.displayName, Colors.indigo),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.location,
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey[500]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.period,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primaryContainer),
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
