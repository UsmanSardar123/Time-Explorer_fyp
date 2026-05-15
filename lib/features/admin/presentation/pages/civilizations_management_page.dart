import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/admin/presentation/manager/admin_provider.dart';

class CivilizationsManagementPage extends StatefulWidget {
  const CivilizationsManagementPage({super.key});

  @override
  State<CivilizationsManagementPage> createState() =>
      _CivilizationsManagementPageState();
}

class _CivilizationsManagementPageState
    extends State<CivilizationsManagementPage> {
  String _query = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchCivilizations();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filtered(List<Map<String, dynamic>> all) {
    if (_query.isEmpty) return all;
    final q = _query.toLowerCase();
    return all
        .where((c) =>
            (c['name'] as String? ?? '').toLowerCase().contains(q) ||
            (c['region'] as String? ?? '').toLowerCase().contains(q) ||
            (c['timePeriod'] as String? ?? '').toLowerCase().contains(q))
        .toList();
  }

  Future<void> _confirmDelete(
      BuildContext ctx, AdminProvider provider, Map<String, dynamic> civ) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Civilization',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        content: Text(
          'Delete "${civ['name']}"? All linked characters in this civilization will lose their civilizationId.',
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
      await provider.removeCivilization(civ['id'] as String);
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('"${civ['name']}" deleted.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Civilizations',
          style: GoogleFonts.plusJakartaSans(
              color: Colors.white, fontWeight: FontWeight.w800),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search civilizations…',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<AdminProvider>(
        builder: (ctx, provider, _) {
          if (provider.isCivilizationsLoading && provider.civilizations.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryContainer));
          }

          if (provider.civilizationsError != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                  const SizedBox(height: 12),
                  Text(provider.civilizationsError!,
                      style: GoogleFonts.beVietnamPro(color: Colors.redAccent)),
                  TextButton(
                    onPressed: () => provider.fetchCivilizations(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final items = _filtered(provider.civilizations);

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_balance_rounded,
                      size: 64, color: Colors.black26),
                  const SizedBox(height: 16),
                  Text(
                    _query.isEmpty
                        ? 'No civilizations seeded yet.\nUse the dashboard to seed one.'
                        : 'No results for "$_query".',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.beVietnamPro(color: Colors.black45),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchCivilizations(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) => _CivTile(
                civ: items[i],
                onDelete: () => _confirmDelete(ctx, provider, items[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CivTile extends StatelessWidget {
  final Map<String, dynamic> civ;
  final VoidCallback onDelete;

  const _CivTile({required this.civ, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final personalityIds = (civ['personalityIds'] as List?)?.length ?? 0;
    final themeColor =
        _hexColor(civ['themeColor'] as String? ?? '#5B7FA6');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: themeColor.withValues(alpha: 0.15),
          child: Icon(Icons.account_balance_rounded, color: themeColor, size: 22),
        ),
        title: Text(
          civ['name'] as String? ?? 'Unknown',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              civ['timePeriod'] as String? ?? '',
              style: GoogleFonts.beVietnamPro(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$personalityIds personalities',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        color: themeColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                if (civ['region'] != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    civ['region'] as String,
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 11, color: Colors.black45),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }

  Color _hexColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}
