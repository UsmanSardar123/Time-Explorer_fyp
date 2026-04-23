import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:timeexplorer/features/auth/presentation/providers/auth_provider.dart';
import 'package:timeexplorer/features/bookmarks/presentation/providers/bookmark_provider.dart';
import 'package:timeexplorer/features/profile/presentation/providers/profile_provider.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/gamified_components.dart';
import 'package:timeexplorer/features/profile/data/services/profile_image_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  String? _localImagePath;
  Uint8List? _webImageBytes; // For web preview
  bool _isUploadingImage = false;
  late AnimationController _ringCtrl;
  late final ProfileImageService _imageService;

  @override
  void initState() {
    super.initState();
    _imageService = ProfileImageService.create();
    _ringCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    _loadLocalImage();
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProfileProvider>().loadProfile(userId);
      });
    }
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadLocalImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _localImagePath = prefs.getString('local_profile_image'));
  }

  /// Picks an image via [ProfileImageService], validates JPG/JPEG, compresses,
  /// and uploads to Firebase Storage.
  Future<void> _pickImage({required bool fromCamera}) async {
    try {
      final result = fromCamera
          ? await _imageService.pickFromCamera()
          : await _imageService.pickFromGallery();

      // Handle errors from the service
      if (result is ProfileImageError) {
        if (result.message == 'cancelled') return; // user cancelled
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

      // Immediately show preview
      if (kIsWeb && result.bytes != null) {
        setState(() => _webImageBytes = result.bytes);
      } else if (!kIsWeb && result.file != null) {
        final prefs = await SharedPreferences.getInstance();
        final path = (result.file as File).path;
        await prefs.setString('local_profile_image', path);
        setState(() => _localImagePath = path);
      }

      // Upload to backend
      final provider = context.read<ProfileProvider>();
      final downloadUrl = await provider.uploadProfileImage(result);

      if (downloadUrl != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text('Profile photo updated!'),
              ],
            ),
            backgroundColor: AppTheme.primaryContainer,
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
      debugPrint('[ProfilePage] _pickImage error: $e');
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
      backgroundColor: AppTheme.surfaceLowest,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 36, height: 4, decoration: BoxDecoration(color: AppTheme.outlineVariant, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('Update Profile Photo', style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.onSurface)),
            const SizedBox(height: 6),
            Text(
              'Only JPG / JPEG images are accepted',
              style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppTheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: CircleAvatar(backgroundColor: AppTheme.surfaceLow, child: const Icon(Icons.camera_alt_rounded, color: AppTheme.primaryContainer)),
              title: Text('Take Photo', style: GoogleFonts.plusJakartaSans(color: AppTheme.onSurface, fontWeight: FontWeight.w600)),
              subtitle: Text('Use your camera', style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppTheme.onSurfaceVariant)),
              onTap: () { Navigator.pop(context); _pickImage(fromCamera: true); },
            ),
            ListTile(
              leading: CircleAvatar(backgroundColor: AppTheme.surfaceLow, child: const Icon(Icons.photo_library_rounded, color: AppTheme.primaryContainer)),
              title: Text('Choose from Gallery', style: GoogleFonts.plusJakartaSans(color: AppTheme.onSurface, fontWeight: FontWeight.w600)),
              subtitle: Text('JPG or JPEG only', style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppTheme.onSurfaceVariant)),
              onTap: () { Navigator.pop(context); _pickImage(fromCamera: false); },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final bookmarkCount = context.watch<BookmarkProvider>().bookmarkedPlaces.length;
    final gam = context.watch<GamificationProvider>().progress;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(profile, gam)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildStatsRow(gam, bookmarkCount),
                  const SizedBox(height: 28),
                  _buildMenuSection(context, profile),
                  const SizedBox(height: 20),
                  _buildSignOutButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic profile, dynamic gam) {
    // Resolve the image to display in the circle
    ImageProvider? imageProvider;
    if (_webImageBytes != null) {
      imageProvider = MemoryImage(_webImageBytes!);
    } else if (!kIsWeb && _localImagePath != null && File(_localImagePath!).existsSync()) {
      imageProvider = FileImage(File(_localImagePath!));
    } else if (profile?.photoUrl != null) {
      imageProvider = NetworkImage(profile!.photoUrl!);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 64, 20, 28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        border: const Border(bottom: BorderSide(color: AppTheme.outlineVariant, width: 1)),
      ),
      child: Column(
        children: [
          // ── Dedicated Profile Circle ──────────────────────────────────────
          Stack(
            alignment: Alignment.center,
            children: [
              // Animated gradient ring
              RotationTransition(
                turns: _ringCtrl,
                child: Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        AppTheme.primaryContainer.withValues(alpha: 0.0),
                        AppTheme.primaryContainer.withValues(alpha: 0.7),
                        AppTheme.primaryContainer.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Tap target & avatar
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  width: 122,
                  height: 122,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.surfaceLowest,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryContainer.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: AppTheme.surfaceLow,
                        backgroundImage: imageProvider,
                        child: imageProvider == null && !_isUploadingImage
                            ? const Icon(Icons.person_rounded, size: 44, color: AppTheme.onSurfaceVariant)
                            : null,
                      ),
                      if (_isUploadingImage)
                        const CircularProgressIndicator(color: AppTheme.primaryContainer, strokeWidth: 2.5),
                    ],
                  ),
                ),
              ),
              // Camera badge
              Positioned(
                bottom: 2,
                right: 2,
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.surfaceLowest, width: 2.5),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            profile?.displayName ?? 'Explorer',
            style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            profile?.email ?? '',
            style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppTheme.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Level ${gam.level} Explorer',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(dynamic gam, int bookmarks) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('XP', '${gam.totalXP ?? 0}', AppTheme.primaryContainer)),
        const SizedBox(width: 10),
        Expanded(child: _buildStatCard('Streak', '${gam.streak}d', AppTheme.amber)),
        const SizedBox(width: 10),
        Expanded(child: AnimatedCard(
          onTap: () => context.push('/bookmarks'),
          child: _buildStatCard('Saved', '$bookmarks', const Color(0xFF059669)),
        )),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.outlineVariant, width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppTheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, dynamic profile) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant, width: 1),
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.person_outline_rounded, 'Personal Info', () async {
            final p = context.read<ProfileProvider>().profile;
            if (p != null) {
              await context.push('/profile/personal-info', extra: p);
              _loadLocalImage();
            }
          }),
          _buildDivider(),
          _buildMenuItem(Icons.bookmark_outline_rounded, 'My Collection', () => context.push('/bookmarks')),
          _buildDivider(),
          _buildMenuItem(Icons.timeline_rounded, 'Journey History', () => context.push('/progress')),
          _buildDivider(),
          _buildMenuItem(Icons.settings_outlined, 'Settings', () => context.push('/settings')),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.primaryContainer, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: AppTheme.outlineVariant, indent: 20, endIndent: 20);
  }

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => context.read<AuthProvider>().signOut(),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text('Sign Out'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.error,
          side: const BorderSide(color: AppTheme.error, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
