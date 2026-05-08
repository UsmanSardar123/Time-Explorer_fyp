import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/admin/presentation/manager/admin_provider.dart';
import 'package:timeexplorer/features/admin/data/models/event_model.dart';
import 'package:timeexplorer/features/event_explorer/domain/entities/historical_event.dart';
import 'package:timeexplorer/features/event_explorer/domain/entities/event_category.dart';

class EventFormPage extends StatefulWidget {
  final HistoricalEvent? event;
  const EventFormPage({super.key, this.event});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  static const _primary     = AppTheme.primaryContainer;
  static const _primaryLight = Color(0xFF818CF8);
  static const _dark        = Color(0xFF0F172A);
  static const _bg          = AppTheme.background;
  static const _surface     = AppTheme.surfaceLow;

  final _formKey   = GlobalKey<FormState>();
  bool  _isSaving  = false;

  late final TextEditingController _title;
  late final TextEditingController _period;
  late final TextEditingController _location;
  late final TextEditingController _description;
  late final TextEditingController _imageUrl;
  late final TextEditingController _importance;
  late final TextEditingController _latitude;
  late final TextEditingController _longitude;
  late final TextEditingController _youtubeUrl;
  
  late final TextEditingController _factInput;
  late final TextEditingController _galleryInput;
  
  // Timeline inputs
  late final TextEditingController _tlDateInput;
  late final TextEditingController _tlDescInput;

  EventCategory _category = EventCategory.warsAndConflicts;
  final List<String> _keyFacts = [];
  final List<String> _galleryUrls = [];
  final List<TimelinePoint> _timeline = [];

  bool get _isEdit => widget.event != null;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _title       = TextEditingController(text: e?.title ?? '');
    _period      = TextEditingController(text: e?.period ?? '');
    _location    = TextEditingController(text: e?.location ?? '');
    _description = TextEditingController(text: e?.description ?? '');
    _imageUrl    = TextEditingController(text: e?.imageUrl is String ? e!.imageUrl : '');
    _importance  = TextEditingController(text: e?.importanceLevel.toString() ?? '3');
    _latitude    = TextEditingController(text: e?.latitude?.toString() ?? '');
    _longitude   = TextEditingController(text: e?.longitude?.toString() ?? '');
    _youtubeUrl  = TextEditingController(text: e?.youtubeUrl ?? '');
    
    _factInput    = TextEditingController();
    _galleryInput = TextEditingController();
    _tlDateInput  = TextEditingController();
    _tlDescInput  = TextEditingController();

    if (e != null) {
      _category = e.category;
      _keyFacts.addAll(e.keyFacts);
      _galleryUrls.addAll(e.galleryUrls.cast<String>());
      _timeline.addAll(e.timeline);
    }
  }

  @override
  void dispose() {
    for (final c in [
      _title, _period, _location, _description, _imageUrl,
      _importance, _latitude, _longitude, _youtubeUrl,
      _factInput, _galleryInput, _tlDateInput, _tlDescInput,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final model = EventModel(
      id: widget.event?.id ?? '',
      title: _title.text.trim(),
      category: _category,
      period: _period.text.trim(),
      location: _location.text.trim(),
      description: _description.text.trim(),
      imageUrl: _imageUrl.text.trim(),
      importanceLevel: int.tryParse(_importance.text.trim()) ?? 3,
      keyFacts: List.from(_keyFacts),
      galleryUrls: List.from(_galleryUrls),
      timeline: List.from(_timeline),
      latitude: double.tryParse(_latitude.text.trim()),
      longitude: double.tryParse(_longitude.text.trim()),
      youtubeUrl: _youtubeUrl.text.trim().isEmpty ? null : _youtubeUrl.text.trim(),
    );

    final provider = context.read<AdminProvider>();
    try {
      if (_isEdit) {
        await provider.editEvent(model);
      } else {
        await provider.addEvent(model);
      }
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_isEdit
              ? '"${model.title}" updated successfully.'
              : '"${model.title}" added successfully.'),
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
          _isEdit ? 'Edit Event' : 'Add New Event',
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
            _field('Title *', _title, required: true),
            const SizedBox(height: 14),
            _categoryDropdown(),
            const SizedBox(height: 14),
            _field('Period / Date *', _period, required: true, hint: 'e.g. 1939 – 1945 or 1789'),
            const SizedBox(height: 14),
            _field('Location *', _location, required: true, hint: 'e.g. Europe, Global'),
            const SizedBox(height: 14),
            _field('Description *', _description, required: true, maxLines: 4),
            const SizedBox(height: 14),
            _field('Hero Image URL *', _imageUrl, required: true, hint: 'https://...'),
            const SizedBox(height: 24),

            _sectionHeader('Attributes'),
            _field(
              'Importance Level (1–5) *',
              _importance,
              required: true,
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 1 || n > 5) return 'Enter a number between 1 and 5';
                return null;
              },
            ),
            const SizedBox(height: 14),
            _field('YouTube URL (optional)', _youtubeUrl, hint: 'https://youtube.com/watch?v=...'),
            const SizedBox(height: 24),

            _sectionHeader('Timeline Points'),
            _timelineBuilder(),
            const SizedBox(height: 24),

            _sectionHeader('Key Facts'),
            _dynamicList(
              items: _keyFacts,
              controller: _factInput,
              hint: 'Add a fact and press +',
              onAdd: () {
                final v = _factInput.text.trim();
                if (v.isNotEmpty) setState(() { _keyFacts.add(v); _factInput.clear(); });
              },
              onRemove: (i) => setState(() => _keyFacts.removeAt(i)),
            ),
            const SizedBox(height: 24),

            _sectionHeader('Gallery Images (URLs)'),
            _dynamicList(
              items: _galleryUrls,
              controller: _galleryInput,
              hint: 'Paste image URL and press +',
              onAdd: () {
                final v = _galleryInput.text.trim();
                if (v.isNotEmpty) setState(() { _galleryUrls.add(v); _galleryInput.clear(); });
              },
              onRemove: (i) => setState(() => _galleryUrls.removeAt(i)),
              isUrl: true,
            ),
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
                    _isEdit ? 'Update Event' : 'Add Event',
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
    return DropdownButtonFormField<EventCategory>(
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
      items: EventCategory.values
          .map((c) => DropdownMenuItem(value: c, child: Text(c.displayName, style: GoogleFonts.plusJakartaSans(fontSize: 14))))
          .toList(),
      onChanged: (v) => setState(() => _category = v!),
    );
  }

  Widget _timelineBuilder() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _field('Date', _tlDateInput, hint: 'e.g. July 14')),
            const SizedBox(width: 8),
            Expanded(child: _field('Description', _tlDescInput, hint: 'e.g. Storming of Bastille')),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () {
                if (_tlDateInput.text.isNotEmpty && _tlDescInput.text.isNotEmpty) {
                  setState(() {
                    _timeline.add(TimelinePoint(date: _tlDateInput.text.trim(), description: _tlDescInput.text.trim()));
                    _tlDateInput.clear();
                    _tlDescInput.clear();
                  });
                }
              },
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(backgroundColor: _primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ],
        ),
        if (_timeline.isNotEmpty) ...[
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _timeline.length,
            itemBuilder: (context, i) => ListTile(
              dense: true,
              leading: const Icon(Icons.circle, size: 8, color: _primary),
              title: Text(_timeline[i].date, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_timeline[i].description),
              trailing: IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => setState(() => _timeline.removeAt(i))),
            ),
          ),
        ],
      ],
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
