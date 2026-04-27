import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character_category.dart';
import 'package:timeexplorer/features/admin/presentation/manager/admin_provider.dart';
import 'package:timeexplorer/features/admin/data/models/character_model.dart';

class CharacterFormPage extends StatefulWidget {
  final Character? character;
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
  late final TextEditingController _bio;
  late final TextEditingController _chatPrompt;
  late final TextEditingController _tone;
  late final TextEditingController _commStyle;
  late final TextEditingController _domainKnowledge;
  late final TextEditingController _specialtiesInput;
  late final TextEditingController _contributionsInput;
  late final TextEditingController _achievementInput;

  CharacterCategory _category = CharacterCategory.scientists;
  final List<String> _achievements = [];
  final List<String> _specialties = [];
  final List<String> _contributions = [];
  final List<QuizQuestion> _quiz = [];

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
    _birthYear        = TextEditingController(text: c?.dob ?? '');
    _deathYear        = TextEditingController(text: c?.dod ?? '');
    _nationality      = TextEditingController(text: c?.nationality ?? c?.origin ?? '');
    _legacy           = TextEditingController(text: c?.legacy ?? '');
    _bio              = TextEditingController(text: c?.bio ?? '');
    _chatPrompt       = TextEditingController(text: c?.chatPrompt ?? '');
    _tone             = TextEditingController(text: c?.tone ?? '');
    _commStyle        = TextEditingController(text: c?.communicationStyle ?? '');
    _domainKnowledge  = TextEditingController(text: c?.domainKnowledge ?? '');
    _specialtiesInput = TextEditingController();
    _contributionsInput = TextEditingController();
    _achievementInput = TextEditingController();

    if (c?.category != null) {
      _category = c!.category;
    }
    if (c?.achievements != null) _achievements.addAll(c!.achievements!);
    if (c?.specialties != null) _specialties.addAll(c!.specialties);
    if (c?.contributions != null) _contributions.addAll(c!.contributions);
    if (c?.quiz != null) _quiz.addAll(c!.quiz);
  }

  @override
  void dispose() {
    for (final ctrl in [
      _name, _title, _era, _description, _imageUrl,
      _birthYear, _deathYear, _nationality, _legacy,
      _bio, _chatPrompt, _tone, _commStyle, _domainKnowledge,
      _specialtiesInput, _contributionsInput, _achievementInput,
    ]) { ctrl.dispose(); }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final model = CharacterModel(
      id:                 widget.character?.id ?? '',
      name:               _name.text.trim(),
      category:           _category,
      era:                _era.text.trim(),
      description:        _description.text.trim(),
      imageUrl:           _imageUrl.text.trim(),
      title:              _title.text.trim(),
      dob:                _birthYear.text.trim(),
      dod:                _deathYear.text.trim(),
      nationality:        _nationality.text.trim(),
      origin:             _nationality.text.trim(),
      achievements:       _achievements,
      legacy:             _legacy.text.trim(),
      bio:                _bio.text.trim(),
      chatPrompt:         _chatPrompt.text.trim(),
      tone:               _tone.text.trim(),
      communicationStyle: _commStyle.text.trim(),
      domainKnowledge:    _domainKnowledge.text.trim(),
      specialties:        _specialties,
      contributions:      _contributions,
      quiz:               _quiz,
      facts:              widget.character?.facts ?? [],
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

            _sectionHeader('Intelligence Profile'),
            _field('Full Biography *', _bio, required: true, maxLines: 6),
            const SizedBox(height: 14),
            _field('Description (Short) *', _description, required: true, maxLines: 2),
            const SizedBox(height: 14),
            _field('Legacy', _legacy, maxLines: 3, hint: 'Long-lasting impact…'),
            const SizedBox(height: 24),

            _sectionHeader('AI Personality (Chat)'),
            _field('System Prompt *', _chatPrompt, required: true, maxLines: 4, hint: 'You are Leonardo da Vinci...'),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _field('Tone', _tone, hint: 'e.g. Scholarly')),
              const SizedBox(width: 12),
              Expanded(child: _field('Comm. Style', _commStyle, hint: 'e.g. Italian-accented')),
            ]),
            const SizedBox(height: 14),
            _field('Domain Knowledge', _domainKnowledge, hint: 'e.g. Renaissance Art, Anatomy'),
            const SizedBox(height: 24),

            _sectionHeader('Personal Details'),
            Row(children: [
              Expanded(child: _field('Birth Year', _birthYear, hint: 'e.g. 69 BC')),
              const SizedBox(width: 12),
              Expanded(child: _field('Death Year', _deathYear, hint: 'e.g. 30 BC')),
            ]),
            const SizedBox(height: 14),
            _field('Nationality / Origin', _nationality, hint: 'e.g. Egyptian, Roman'),
            const SizedBox(height: 24),

            _sectionHeader('Media'),
            _field('Image URL', _imageUrl, hint: 'https://…'),
            const SizedBox(height: 24),

            _sectionHeader('Expertise'),
            _listInput('Specialties', _specialtiesInput, _specialties, () => _addItem(_specialtiesInput, _specialties)),
            const SizedBox(height: 14),
            _listInput('Contributions', _contributionsInput, _contributions, () => _addItem(_contributionsInput, _contributions)),
            const SizedBox(height: 14),
            _listInput('Key Achievements', _achievementInput, _achievements, () => _addItem(_achievementInput, _achievements)),
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
    return DropdownButtonFormField<CharacterCategory>(
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
      items: CharacterCategory.values
          .map((c) => DropdownMenuItem(value: c, child: Text(c.displayName, style: GoogleFonts.plusJakartaSans(fontSize: 14))))
          .toList(),
      onChanged: (v) => setState(() => _category = v!),
    );
  }

  Widget _listInput(String label, TextEditingController ctrl, List<String> list, VoidCallback onAdd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: ctrl,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: _dark),
                onSubmitted: (_) => onAdd(),
                decoration: InputDecoration(
                  hintText: 'Add $label and press +',
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
                onTap: onAdd,
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        if (list.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: List.generate(list.length, (i) => Chip(
              label: Text(list[i], style: GoogleFonts.plusJakartaSans(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              backgroundColor: _surface,
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => setState(() => list.removeAt(i)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )),
          ),
        ],
      ],
    );
  }

  void _addItem(TextEditingController ctrl, List<String> list) {
    final v = ctrl.text.trim();
    if (v.isNotEmpty) setState(() { list.add(v); ctrl.clear(); });
  }
}
