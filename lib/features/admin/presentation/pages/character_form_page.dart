import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/admin/data/models/character_model.dart';
import 'package:timeexplorer/features/admin/domain/entities/character_entity.dart';
import 'package:timeexplorer/features/admin/presentation/manager/admin_provider.dart';

class CharacterFormPage extends StatefulWidget {
  final CharacterEntity? character;
  const CharacterFormPage({super.key, this.character});

  @override
  State<CharacterFormPage> createState() => _CharacterFormPageState();
}

class _CharacterFormPageState extends State<CharacterFormPage> {
  static const _primary      = AppTheme.primaryContainer;
  static const _primaryLight = Color(0xFF818CF8);
  static const _dark         = Color(0xFF0F172A);
  static const _bg           = AppTheme.background;
  static const _surface      = AppTheme.surfaceLow;

  final _formKey  = GlobalKey<FormState>();
  bool _isSaving  = false;

  late final TextEditingController _name;
  late final TextEditingController _title;
  late final TextEditingController _era;
  late final TextEditingController _description;
  late final TextEditingController _imageUrl;
  late final TextEditingController _birthYear;
  late final TextEditingController _deathYear;
  late final TextEditingController _nationality;
  late final TextEditingController _legacy;
  late final TextEditingController _achievementInput;

  static const _categories = ['Ruler', 'Scientist', 'Artist', 'Military', 'Philosopher', 'Explorer', 'Other'];
  String _category = 'Other';
  final List<String> _achievements = [];

  bool get _isEdit => widget.character != null;

  @override
  void initState() {
    super.initState();
    final c = widget.character;
    _name             = TextEditingController(text: c?.name ?? '');
    _title            = TextEditingController(text: c?.title ?? '');
    _era              = TextEditingController(text: c?.era ?? '');
    _description      = TextEditingController(text: c?.description ?? '');
    _imageUrl         = TextEditingController(text: c?.imageUrl ?? '');
    _birthYear        = TextEditingController(text: c?.birthYear ?? '');
    _deathYear        = TextEditingController(text: c?.deathYear ?? '');
    _nationality      = TextEditingController(text: c?.nationality ?? '');
    _legacy           = TextEditingController(text: c?.legacy ?? '');
    _achievementInput = TextEditingController();

    if (c?.category != null && _categories.contains(c!.category)) {
      _category = c.category;
    }
    if (c?.achievements != null) _achievements.addAll(c!.achievements!);
  }

  @override
  void dispose() {
    for (final ctrl in [
      _name, _title, _era, _description, _imageUrl,
      _birthYear, _deathYear, _nationality, _legacy, _achievementInput,
    ]) { ctrl.dispose(); }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final model = CharacterModel(
      id:           widget.character?.id ?? '',
      name:         _name.text.trim(),
      category:     _category,
      era:          _era.text.trim(),
      description:  _description.text.trim(),
      imageUrl:     _imageUrl.text.trim().isEmpty  ? null : _imageUrl.text.trim(),
      title:        _title.text.trim().isEmpty     ? null : _title.text.trim(),
      birthYear:    _birthYear.text.trim().isEmpty ? null : _birthYear.text.trim(),
      deathYear:    _deathYear.text.trim().isEmpty ? null : _deathYear.text.trim(),
      nationality:  _nationality.text.trim().isEmpty ? null : _nationality.text.trim(),
      achievements: _achievements.isEmpty ? null : List.from(_achievements),
      legacy:       _legacy.text.trim().isEmpty ? null : _legacy.text.trim(),
    );

    final provider = context.read<AdminProvider>();
    try {
      if (_isEdit) {
        await provider.editCharacter(model);
      } else {
        await provider.addCharacter(model);
      }
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_isEdit ? '"${model.name}" updated.' : '"${model.name}" added.'),
          backgroundColor: _primary,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
          _isEdit ? 'Edit Character' : 'Add Character',
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save_rounded, color: Colors.white),
                label: Text(
                  _isEdit ? 'Update' : 'Save',
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _sectionHeader('Identity'),
            _field('Name *', _name, required: true),
            const SizedBox(height: 14),
            _field('Title / Role', _title, hint: 'e.g. Pharaoh, Emperor, Scientist'),
            const SizedBox(height: 14),
            _categoryDropdown(),
            const SizedBox(height: 14),
            _field('Era / Period *', _era, required: true, hint: 'e.g. Ancient Egypt, Roman Empire'),
            const SizedBox(height: 24),

            _sectionHeader('Biography'),
            _field('Description *', _description, required: true, maxLines: 4),
            const SizedBox(height: 14),
            _field('Legacy', _legacy, maxLines: 3, hint: 'Long-lasting impact…'),
            const SizedBox(height: 24),

            _sectionHeader('Personal Details'),
            Row(children: [
              Expanded(child: _field('Birth Year', _birthYear, hint: 'e.g. 69 BC')),
              const SizedBox(width: 12),
              Expanded(child: _field('Death Year', _deathYear, hint: 'e.g. 30 BC')),
            ]),
            const SizedBox(height: 14),
            _field('Nationality', _nationality, hint: 'e.g. Egyptian, Roman'),
            const SizedBox(height: 24),

            _sectionHeader('Media'),
            _field('Image URL', _imageUrl, hint: 'https://…'),
            const SizedBox(height: 24),

            _sectionHeader('Key Achievements'),
            _achievementsList(),
            const SizedBox(height: 36),

            // Submit button
            SizedBox(
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  icon: Icon(_isEdit ? Icons.save_outlined : Icons.add_circle_outline, color: Colors.white),
                  label: Text(
                    _isEdit ? 'Update Character' : 'Add Character',
                    style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 4, height: 18, decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: _dark)),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    bool required = false,
    int maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: _dark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.black45),
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.black26),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border:             OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _surface)),
        enabledBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _surface)),
        focusedBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryLight, width: 1.5)),
        errorBorder:        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
      ),
      validator: validator ?? (v) {
        if (required && (v == null || v.trim().isEmpty)) return '$label is required';
        return null;
      },
    );
  }

  Widget _categoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _category,
      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: _dark),
      decoration: InputDecoration(
        labelText: 'Category *',
        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.black45),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border:        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _surface)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _surface)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryLight, width: 1.5)),
      ),
      borderRadius: BorderRadius.circular(12),
      items: _categories
          .map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.plusJakartaSans(fontSize: 14))))
          .toList(),
      onChanged: (v) => setState(() => _category = v!),
    );
  }

  Widget _achievementsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _achievementInput,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: _dark),
                onSubmitted: (_) => _addAchievement(),
                decoration: InputDecoration(
                  hintText: 'Add an achievement and press +',
                  hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.black26),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border:        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _surface)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _surface)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryLight, width: 1.5)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: _primary,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: _addAchievement,
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        if (_achievements.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: List.generate(_achievements.length, (i) => Chip(
              label: Text(_achievements[i], style: GoogleFonts.plusJakartaSans(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              backgroundColor: _surface,
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => setState(() => _achievements.removeAt(i)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )),
          ),
        ],
      ],
    );
  }

  void _addAchievement() {
    final v = _achievementInput.text.trim();
    if (v.isNotEmpty) setState(() { _achievements.add(v); _achievementInput.clear(); });
  }
}
