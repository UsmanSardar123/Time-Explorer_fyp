import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' as io;
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/profile/presentation/providers/profile_provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/profile/data/services/profile_image_service.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileEntity profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // ── Design Tokens ─────────────────────────────────────────────────────────
  static const _primary = AppTheme.primaryContainer;
  static const _primaryLight = Color(0xFF818CF8);
  static const _bg = AppTheme.background;
  static const _surfaceLow = AppTheme.surfaceLow;
  static const _surfaceCard = AppTheme.surface;
  static const _textDark = AppTheme.onSurface;
  static const _textMuted = AppTheme.onSurfaceVariant;

  late TextEditingController _displayNameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _dobController;
  final _formKey = GlobalKey<FormState>();

  String? _localImagePath;
  Uint8List? _webImageBytes;
  bool _isUploadingImage = false;
  late final ProfileImageService _imageService;

  @override
  void initState() {
    super.initState();
    _imageService = ProfileImageService.create();
    _displayNameController = TextEditingController(text: widget.profile.displayName);
    _usernameController = TextEditingController(text: widget.profile.username ?? '');
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
    _dobController = TextEditingController(text: widget.profile.dob ?? '');
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  /// Picks, validates (JPG/JPEG only), compresses, and uploads using [ProfileImageService].
  Future<void> _pickImage({required bool fromCamera}) async {
    try {
      final result = fromCamera
          ? await _imageService.pickFromCamera()
          : await _imageService.pickFromGallery();

      if (result is ProfileImageError) {
        if (result.message == 'cancelled') return;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(result.message)),
                ],
              ),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
        return;
      }

      if (result is! ProfileImageResult) return;

      setState(() => _isUploadingImage = true);

      // Instant preview
      if (mounted) {
        if (kIsWeb && result.bytes != null) {
          setState(() => _webImageBytes = result.bytes);
        } else if (!kIsWeb && result.file != null) {
          setState(() => _localImagePath = (result.file as io.File).path);
        }
      }

      // Upload
      final provider = context.read<ProfileProvider>();
      final downloadUrl = await provider.uploadProfileImage(result);

      if (downloadUrl != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile photo uploaded!'),
            backgroundColor: _primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${provider.error ?? "Unknown error"}'),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      debugPrint('[EditProfilePage] _pickImage error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Something went wrong. Please try again.'),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update Profile Photo',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Only JPG / JPEG images are accepted',
                style: GoogleFonts.beVietnamPro(fontSize: 12, color: _textMuted),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: _surfaceLow,
                  child: const Icon(Icons.camera_alt_rounded, color: _primary),
                ),
                title: Text('Take Photo', style: GoogleFonts.plusJakartaSans(color: _textDark, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(fromCamera: true);
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: _surfaceLow,
                  child: const Icon(Icons.photo_library_rounded, color: _primary),
                ),
                title: Text('Choose from Gallery', style: GoogleFonts.plusJakartaSans(color: _textDark, fontWeight: FontWeight.w600)),
                subtitle: Text('JPG or JPEG only', style: GoogleFonts.beVietnamPro(fontSize: 12, color: _textMuted)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(fromCamera: false);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: _primary,
            colorScheme: const ColorScheme.light(primary: _primary),
            dialogTheme: const DialogThemeData(backgroundColor: _bg),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ProfileProvider>();
      
      if (_usernameController.text != widget.profile.username) {
        final isUnique = await provider.isUsernameUnique(_usernameController.text);
        if (!isUnique) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Username is already taken'),
                backgroundColor: AppTheme.primaryContainer,
              ),
            );
          }
          return;
        }
      }

      // CRITICAL FIX: Use the latest profile from the provider to avoid overwriting photoUrl
      final currentProfile = provider.profile ?? widget.profile;
      
      final updatedProfile = currentProfile.copyWith(
        displayName: _displayNameController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        dob: _dobController.text,
      );

      await provider.updateProfile(updatedProfile);

      if (mounted) {
        if (provider.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.error!),
              backgroundColor: AppTheme.primaryContainer,
            ),
          );
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: _primary,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text(
          'Personal Info',
          style: GoogleFonts.plusJakartaSans(
            color: _textDark,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        backgroundColor: _bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: _textDark),
        actions: [
          IconButton(
            onPressed: _saveProfile,
            icon: const Icon(Icons.check_rounded, color: _primary),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildProfileImageSection(),
                      const SizedBox(height: 48),
                      // Input Fields
                      _buildTextField(
                        controller: _displayNameController,
                        label: 'Full Name',
                        icon: Icons.person_outline_rounded,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _usernameController,
                        label: 'Username',
                        icon: Icons.alternate_email_rounded,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter a username' : null,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          child: _buildTextField(
                            controller: _dobController,
                            label: 'Date of Birth',
                            icon: Icons.calendar_today_rounded,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _bioController,
                        label: 'Bio',
                        icon: Icons.info_outline_rounded,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Save Changes',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              if (provider.isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.1),
                  child: const Center(child: CircularProgressIndicator(color: _primary)),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileImageSection() {
    // Resolve the image for the circle preview
    ImageProvider? imageProvider;
    if (_webImageBytes != null) {
      imageProvider = MemoryImage(_webImageBytes!);
    } else if (!kIsWeb && _localImagePath != null && io.File(_localImagePath!).existsSync()) {
      imageProvider = FileImage(io.File(_localImagePath!));
    } else if (widget.profile.photoUrl != null) {
      imageProvider = NetworkImage(widget.profile.photoUrl!);
    }

    return Center(
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [_primary, _primaryLight]),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 64,
                  backgroundColor: _surfaceCard,
                  backgroundImage: imageProvider,
                  child: imageProvider == null && !_isUploadingImage
                      ? const Icon(Icons.person_rounded, size: 48, color: _primary)
                      : null,
                ),
                if (_isUploadingImage)
                  const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: _bg, width: 3),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _textDark.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.plusJakartaSans(
          color: _textDark,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.plusJakartaSans(
            color: _textMuted,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: _primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
