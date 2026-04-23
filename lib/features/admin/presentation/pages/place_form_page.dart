import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/admin/presentation/manager/admin_provider.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';

class PlaceFormPage extends StatefulWidget {
  final Place? place;
  const PlaceFormPage({super.key, this.place});

  @override
  State<PlaceFormPage> createState() => _PlaceFormPageState();
}

class _PlaceFormPageState extends State<PlaceFormPage> {
  // ── Design tokens ──────────────────────────────────────────────────────────
  static const _primary     = AppTheme.primaryContainer;
  static const _primaryLight = Color(0xFF818CF8);
  static const _dark        = Color(0xFF0F172A);
  static const _bg          = AppTheme.background;
  static const _surface     = AppTheme.surfaceLow;

  // ── Form state ─────────────────────────────────────────────────────────────
  final _formKey   = GlobalKey<FormState>();
  bool  _isSaving  = false;

  late final TextEditingController _name;
  late final TextEditingController _location;
  late final TextEditingController _description;
  late final TextEditingController _imageUrl;
  late final TextEditingController _history;
  late final TextEditingController _civilization;
  late final TextEditingController _builtBy;
  late final TextEditingController _constructionDate;
  late final TextEditingController _architecturalStyle;
  late final TextEditingController _openingHours;
  late final TextEditingController _ticketPrice;
  late final TextEditingController _bestTime;
  late final TextEditingController _visitDuration;
  late final TextEditingController _didYouKnow;
  late final TextEditingController _latitude;
  late final TextEditingController _longitude;
  late final TextEditingController _rating;
  late final TextEditingController _keyFactInput;
  late final TextEditingController _imageInput;

  static const _categories = ['Historical', 'Archaeological', 'Natural', 'Cultural', 'Religious', 'Other'];
  String _category = 'Historical';

  final List<String> _keyFacts = [];
  final List<String> _images   = [];

  bool get _isEdit => widget.place != null;

  @override
  void initState() {
    super.initState();
    final p = widget.place;
    _name               = TextEditingController(text: p?.name ?? '');
    _location           = TextEditingController(text: p?.location ?? '');
    _description        = TextEditingController(text: p?.description ?? '');
    _imageUrl           = TextEditingController(text: p?.imageUrl ?? '');
    _history            = TextEditingController(text: p?.history ?? '');
    _civilization       = TextEditingController(text: p?.civilization ?? '');
    _builtBy            = TextEditingController(text: p?.builtBy ?? '');
    _constructionDate   = TextEditingController(text: p?.constructionDate ?? '');
    _architecturalStyle = TextEditingController(text: p?.architecturalStyle ?? '');
    _openingHours       = TextEditingController(text: p?.openingHours ?? '');
    _ticketPrice        = TextEditingController(text: p?.ticketPrice ?? '');
    _bestTime           = TextEditingController(text: p?.bestTimeToVisit ?? '');
    _visitDuration      = TextEditingController(text: p?.visitDuration ?? '');
    _didYouKnow         = TextEditingController(text: p?.didYouKnow ?? '');
    _latitude           = TextEditingController(text: p?.latitude?.toString() ?? '');
    _longitude          = TextEditingController(text: p?.longitude?.toString() ?? '');
    _rating             = TextEditingController(text: p?.rating.toString() ?? '0.0');
    _keyFactInput       = TextEditingController();
    _imageInput         = TextEditingController();

    if (p?.category != null && _categories.contains(p!.category)) {
      _category = p.category;
    }
    if (p?.keyFacts != null) _keyFacts.addAll(p!.keyFacts!);
    if (p?.images   != null) _images.addAll(p!.images!);
  }

  @override
  void dispose() {
    for (final c in [
      _name, _location, _description, _imageUrl, _history,
      _civilization, _builtBy, _constructionDate, _architecturalStyle,
      _openingHours, _ticketPrice, _bestTime, _visitDuration, _didYouKnow,
      _latitude, _longitude, _rating, _keyFactInput, _imageInput,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final model = PlaceModel(
      id:                 widget.place?.id ?? '',
      name:               _name.text.trim(),
      category:           _category,
      location:           _location.text.trim(),
      description:        _description.text.trim(),
      imageUrl:           _imageUrl.text.trim(),
      history:            _history.text.trim().isEmpty            ? null : _history.text.trim(),
      civilization:       _civilization.text.trim().isEmpty       ? null : _civilization.text.trim(),
      builtBy:            _builtBy.text.trim().isEmpty            ? null : _builtBy.text.trim(),
      constructionDate:   _constructionDate.text.trim().isEmpty   ? null : _constructionDate.text.trim(),
      architecturalStyle: _architecturalStyle.text.trim().isEmpty ? null : _architecturalStyle.text.trim(),
      keyFacts:           _keyFacts.isEmpty ? null : List.from(_keyFacts),
      images:             _images.isEmpty   ? null : List.from(_images),
      openingHours:       _openingHours.text.trim().isEmpty       ? null : _openingHours.text.trim(),
      ticketPrice:        _ticketPrice.text.trim().isEmpty        ? null : _ticketPrice.text.trim(),
      bestTimeToVisit:    _bestTime.text.trim().isEmpty           ? null : _bestTime.text.trim(),
      visitDuration:      _visitDuration.text.trim().isEmpty      ? null : _visitDuration.text.trim(),
      didYouKnow:         _didYouKnow.text.trim().isEmpty         ? null : _didYouKnow.text.trim(),
      latitude:           double.tryParse(_latitude.text.trim()),
      longitude:          double.tryParse(_longitude.text.trim()),
      rating:             double.tryParse(_rating.text.trim()) ?? 0.0,
    );

    final provider = context.read<AdminProvider>();
    try {
      if (_isEdit) {
        await provider.editPlace(model);
      } else {
        await provider.addPlace(model);
      }
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_isEdit
              ? '"${model.name}" updated successfully.'
              : '"${model.name}" added successfully.'),
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
          _isEdit ? 'Edit Place' : 'Add New Place',
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                ),
              ),
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
            _sectionHeader('Basic Information'),
            _field('Name *', _name, required: true),
            const SizedBox(height: 14),
            _categoryDropdown(),
            const SizedBox(height: 14),
            _field('Location *', _location, required: true, hint: 'e.g. Islamabad, Pakistan'),
            const SizedBox(height: 14),
            _field('Description *', _description, required: true, maxLines: 4),
            const SizedBox(height: 14),
            _field('Cover Image URL *', _imageUrl, required: true, hint: 'https://...'),
            const SizedBox(height: 24),

            _sectionHeader('Rating'),
            _field(
              'Rating (0.0 – 5.0) *',
              _rating,
              required: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                final n = double.tryParse(v ?? '');
                if (n == null || n < 0 || n > 5) return 'Enter a number between 0 and 5';
                return null;
              },
            ),
            const SizedBox(height: 24),

            _sectionHeader('Historical Attributes'),
            _field('Civilization', _civilization, hint: 'e.g. Ancient Egypt'),
            const SizedBox(height: 14),
            _field('Built By', _builtBy, hint: 'e.g. Pharaoh Khufu'),
            const SizedBox(height: 14),
            _field('Construction Date', _constructionDate, hint: 'e.g. c. 2560 BCE'),
            const SizedBox(height: 14),
            _field('Architectural Style', _architecturalStyle, hint: 'e.g. Ancient Egyptian Pyramid'),
            const SizedBox(height: 24),

            _sectionHeader('Detailed Content'),
            _field('History', _history, maxLines: 5),
            const SizedBox(height: 14),
            _field('Did You Know?', _didYouKnow, maxLines: 3),
            const SizedBox(height: 24),

            _sectionHeader('Key Facts'),
            _dynamicList(
              items: _keyFacts,
              controller: _keyFactInput,
              hint: 'Add a fact and press +',
              onAdd: () {
                final v = _keyFactInput.text.trim();
                if (v.isNotEmpty) setState(() { _keyFacts.add(v); _keyFactInput.clear(); });
              },
              onRemove: (i) => setState(() => _keyFacts.removeAt(i)),
            ),
            const SizedBox(height: 24),

            _sectionHeader('Additional Images (URLs)'),
            _dynamicList(
              items: _images,
              controller: _imageInput,
              hint: 'Paste image URL and press +',
              onAdd: () {
                final v = _imageInput.text.trim();
                if (v.isNotEmpty) setState(() { _images.add(v); _imageInput.clear(); });
              },
              onRemove: (i) => setState(() => _images.removeAt(i)),
              isUrl: true,
            ),
            const SizedBox(height: 24),

            _sectionHeader('Visiting Information'),
            _field('Opening Hours',     _openingHours, hint: 'e.g. 9:00 AM – 6:00 PM'),
            const SizedBox(height: 14),
            _field('Ticket Price',      _ticketPrice,  hint: 'e.g. Free or Rs. 50'),
            const SizedBox(height: 14),
            _field('Best Time to Visit', _bestTime,    hint: 'e.g. March – April'),
            const SizedBox(height: 14),
            _field('Visit Duration',    _visitDuration, hint: 'e.g. 1–2 hours'),
            const SizedBox(height: 24),

            _sectionHeader('Coordinates (optional)'),
            Row(
              children: [
                Expanded(child: _field('Latitude',  _latitude,  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true))),
                const SizedBox(width: 12),
                Expanded(child: _field('Longitude', _longitude, keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true))),
              ],
            ),
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
                    _isEdit ? 'Update Place' : 'Add Place',
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
          Container(
            width: 4, height: 18,
            decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: _dark),
          ),
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
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: _dark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.black45),
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.black26),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border:        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _surface)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _surface)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryLight, width: 1.5)),
        errorBorder:   OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
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

  Widget _dynamicList({
    required List<String> items,
    required TextEditingController controller,
    required String hint,
    required VoidCallback onAdd,
    required void Function(int) onRemove,
    bool isUrl = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: _dark),
                onSubmitted: (_) => onAdd(),
                decoration: InputDecoration(
                  hintText: hint,
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
        if (items.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: List.generate(items.length, (i) => Chip(
              label: Text(
                isUrl ? 'Image ${i + 1}' : items[i],
                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              backgroundColor: _surface,
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => onRemove(i),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )),
          ),
        ],
      ],
    );
  }
}
