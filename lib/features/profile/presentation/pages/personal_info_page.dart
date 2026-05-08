import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/auth/presentation/providers/auth_provider.dart';
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/profile/presentation/providers/profile_provider.dart';

class PersonalInfoPage extends StatefulWidget {
  final ProfileEntity profile;
  const PersonalInfoPage({super.key, required this.profile});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _dobController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  String? _gender;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.profile.displayName);
    _dobController =
        TextEditingController(text: widget.profile.dob ?? '');
    _phoneController =
        TextEditingController(text: widget.profile.phoneNumber ?? '');
    _addressController =
        TextEditingController(text: widget.profile.address ?? '');
    _gender = widget.profile.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> _saveInfo() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedProfile = ProfileEntity(
      id: widget.profile.id,
      email: widget.profile.email,
      displayName: _nameController.text.trim(),
      username: widget.profile.username,
      photoUrl: widget.profile.photoUrl,
      bio: widget.profile.bio,
      dob: _dobController.text.trim().isEmpty
          ? null
          : _dobController.text.trim(),
      phoneNumber: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      gender: _gender,
      privacySettings: widget.profile.privacySettings,
    );

    try {
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.updateProfile(updatedProfile);

      if (!mounted) return;

      if (profileProvider.error != null) {
        _showSnackbar(profileProvider.error!, isError: true);
        return;
      }

      await context.read<AuthProvider>().refreshCurrentUser();

      if (!mounted) return;
      Navigator.pop(context);
      _showSnackbar('Personal information updated successfully.');
    } catch (e) {
      if (!mounted) return;
      _showSnackbar('Failed to save. Please try again.', isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.beVietnamPro(color: Colors.white),
        ),
        backgroundColor:
            isError ? AppTheme.error : AppTheme.accentGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Date picker ──────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final initial = _parseDob(_dobController.text) ??
        DateTime.now().subtract(const Duration(days: 365 * 18));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      final d = picked.day.toString().padLeft(2, '0');
      final m = picked.month.toString().padLeft(2, '0');
      _dobController.text = '$d/$m/${picked.year}';
    }
  }

  DateTime? _parseDob(String text) {
    try {
      final parts = text.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {}
    return null;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline_rounded,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter your full name'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _dobController,
                label: 'Date of Birth',
                icon: Icons.calendar_today_rounded,
                readOnly: true,
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on_outlined,
                maxLines: 2,
              ),
              const SizedBox(height: 28),
              Text(
                'Gender',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              _GenderSelector(
                selected: _gender,
                onChanged: (val) => setState(() => _gender = val),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Personal Information',
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: AppTheme.onSurface,
        ),
      ),
      actions: [
        Consumer<ProfileProvider>(
          builder: (_, pp, child) => pp.isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryContainer,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: _saveInfo,
                  icon: const Icon(
                    Icons.check_rounded,
                    color: AppTheme.primaryContainer,
                  ),
                  tooltip: 'Save',
                ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.beVietnamPro(
          fontSize: 15, color: AppTheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(icon, color: AppTheme.primaryContainer, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppTheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppTheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: AppTheme.primaryContainer, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppTheme.error, width: 2),
        ),
        filled: true,
        fillColor: AppTheme.surfaceLowest,
        labelStyle: GoogleFonts.beVietnamPro(
            color: AppTheme.onSurfaceVariant, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ── Gender Selector ───────────────────────────────────────────────────────────

class _GenderSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const _GenderSelector(
      {required this.selected, required this.onChanged});

  static const _options = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: RadioGroup<String>(
        groupValue: selected,
        onChanged: onChanged,
        child: Column(
          children: List.generate(_options.length, (i) {
            final option = _options[i];
            final isLast = i == _options.length - 1;
            return Column(
              children: [
                RadioListTile<String>(
                  value: option,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    option,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ),
                if (!isLast)
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: AppTheme.outlineVariant,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
