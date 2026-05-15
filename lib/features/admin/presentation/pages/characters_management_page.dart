import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character_category.dart';
import 'package:timeexplorer/features/admin/presentation/manager/admin_provider.dart';

class CharactersManagementPage extends StatefulWidget {
  const CharactersManagementPage({super.key});

  @override
  State<CharactersManagementPage> createState() => _CharactersManagementPageState();
}

class _CharactersManagementPageState extends State<CharactersManagementPage> {
  static const _primary  = AppTheme.primaryContainer;
  static const _dark     = Color(0xFF0F172A);
  static const _bg       = AppTheme.background;
  static const _surface  = AppTheme.surfaceLow;

  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _civFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AdminProvider>();
      p.fetchCharacters();
      if (p.civilizations.isEmpty) p.fetchCivilizations();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Character> _filtered(List<Character> all) {
    var list = all;
    if (_civFilter != null) {
      list = list.where((c) => c.civilizationId == _civFilter).toList();
    }
    if (_query.isEmpty) return list;
    final q = _query.toLowerCase();
    return list.where((c) =>
        c.name.toLowerCase().contains(q) ||
        c.era.toLowerCase().contains(q) ||
        c.category.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _dark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Manage Characters',
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/characters/form'),
        backgroundColor: _primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Character',
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Consumer<AdminProvider>(
            builder: (_, provider, __) => _buildCivFilters(provider.civilizations),
          ),
          Expanded(
            child: Consumer<AdminProvider>(
              builder: (context, provider, _) {
                if (provider.isCharactersLoading && provider.characters.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: _primary));
                }
                if (provider.charactersError != null) {
                  return _buildError(provider.charactersError!, provider.fetchCharacters);
                }
                final list = _filtered(provider.characters);
                if (list.isEmpty) return _buildEmpty();
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (_, i) => _CharacterTile(
                    character: list[i],
                    index: i,
                    onEdit: () => context.push('/admin/characters/form', extra: list[i]),
                    onDelete: () => _confirmDelete(context, provider, list[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCivFilters(List<Map<String, dynamic>> civs) {
    if (civs.isEmpty) return const SizedBox.shrink();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _civFilter == null,
            onSelected: (_) => setState(() => _civFilter = null),
            selectedColor: _primary.withValues(alpha: 0.15),
          ),
          const SizedBox(width: 8),
          ...civs.map((civ) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(civ['name'] as String? ?? ''),
              selected: _civFilter == civ['id'],
              onSelected: (_) => setState(() =>
                  _civFilter = _civFilter == civ['id'] ? null : civ['id'] as String?),
              selectedColor: _primary.withValues(alpha: 0.15),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: _dark,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _query = v),
        style: GoogleFonts.plusJakartaSans(color: _dark),
        decoration: InputDecoration(
          hintText: 'Search by name, era or category…',
          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.black38),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search_rounded, color: _primary),
          suffixIcon: _query.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black38),
                  onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildError(String error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          const SizedBox(height: 12),
          Text(error, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(backgroundColor: _primary),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_edu_rounded, size: 72, color: _surface),
          const SizedBox(height: 16),
          Text(
            _query.isEmpty ? 'No characters yet. Tap + to add one.' : 'No results for "$_query".',
            style: GoogleFonts.plusJakartaSans(color: Colors.black38, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext ctx, AdminProvider provider, Character c) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Character?', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
        content: Text(
          'Are you sure you want to delete "${c.name}"? This cannot be undone.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && ctx.mounted) {
      await provider.removeCharacter(c.id);
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text('"${c.name}" deleted.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }
}

class _CharacterTile extends StatelessWidget {
  final Character character;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const _primary = AppTheme.primaryContainer;
  static const _dark    = Color(0xFF0F172A);
  static const _surface = AppTheme.surfaceLow;

  const _CharacterTile({
    required this.character,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 400)),
      curve: Curves.easeOut,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: _dark.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            // Avatar / image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), bottomLeft: Radius.circular(20),
              ),
              child: character.imageUrl.isNotEmpty
                  ? Image.network(
                      character.imageUrl,
                      width: 88, height: 88, fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14, color: _dark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (character.title.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        character.title,
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.black45),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _tag(character.category),
                        const SizedBox(width: 6),
                        if (character.civilizationId != null) ...[
                          _civBadge(character.civilizationId!),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            character.era,
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.black38),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                  icon: const Icon(Icons.edit_outlined, color: _primary),
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
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 88, height: 88, color: _surface,
      child: const Icon(Icons.history_edu_rounded, color: _primary, size: 32),
    );
  }

  Widget _tag(CharacterCategory cat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: _primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(cat.name, style: TextStyle(fontSize: 10, color: _primary, fontWeight: FontWeight.w700)),
    );
  }

  Widget _civBadge(String civId) {
    final label = civId.replaceAll('_', ' ').split(' ').map((w) =>
        w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1)).join(' ');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF5B7FA6).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF5B7FA6), fontWeight: FontWeight.w700)),
    );
  }
}
