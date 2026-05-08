import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PlaceImageViewerScreen extends StatefulWidget {
  final List<String> imageUrls;
  final Map<String, String> imageCaptions;
  final int initialIndex;
  final String heroTag;

  const PlaceImageViewerScreen({
    super.key,
    required this.imageUrls,
    required this.imageCaptions,
    required this.initialIndex,
    required this.heroTag,
  });

  @override
  State<PlaceImageViewerScreen> createState() => _PlaceImageViewerScreenState();
}

class _PlaceImageViewerScreenState extends State<PlaceImageViewerScreen> {
  late int _currentIndex;
  late final PageController _pageController;
  bool _barsVisible = true;
  bool _sharing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _pageController.dispose();
    super.dispose();
  }

  String get _currentUrl => widget.imageUrls[_currentIndex];

  void _onPageChanged(int index) => setState(() => _currentIndex = index);
  void _toggleBars() => setState(() => _barsVisible = !_barsVisible);

  // ── Share ─────────────────────────────────────────────────────────────────

  Future<void> _shareCurrentImage() async {
    setState(() => _sharing = true);
    try {
      final file = await DefaultCacheManager().getSingleFile(_currentUrl);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Discovered via TimeExplorer',
      );
    } catch (_) {
      // Fallback: share the URL directly
      await Share.share(_currentUrl);
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> _saveCurrentImage() async {
    setState(() => _saving = true);
    try {
      final permitted = await _requestSavePermission();
      if (!permitted || !mounted) return;

      final file = await DefaultCacheManager().getSingleFile(_currentUrl);
      final bytes = await file.readAsBytes();

      final result = await ImageGallerySaverPlus.saveImage(
        bytes,
        name: 'timeexplorer_${DateTime.now().millisecondsSinceEpoch}',
        quality: 95,
      );

      if (!mounted) return;
      final ok = result is Map && result['isSuccess'] == true;
      _showSnackBar(ok ? '✓ Image saved to gallery' : 'Could not save. Please try again.');
    } catch (_) {
      if (mounted) _showSnackBar('Failed to save image. Please try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Returns true when the caller may proceed with the save.
  Future<bool> _requestSavePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status.isDenied) {
        final result = await Permission.storage.request();
        if (result.isDenied) {
          // User explicitly said No on Android < 10 where this permission matters.
          _showSnackBar('Storage permission is required to save images.');
          return false;
        }
        // result.isPermanentlyDenied here means Android 10+ (OS design) — fall through.
      }
      // Already permanentlyDenied = Android 10+: MediaStore saves without permission.
      return true;
    }

    if (Platform.isIOS) {
      final status = await Permission.photos.status;
      if (status.isPermanentlyDenied) {
        _showSnackBar('Enable Photos access in Settings → TimeExplorer.');
        openAppSettings();
        return false;
      }
      if (status.isDenied) {
        final result = await Permission.photos.request();
        if (!result.isGranted && !result.isLimited) {
          _showSnackBar('Photo library access is required to save images.');
          return false;
        }
      }
    }

    return true;
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleBars,
        child: Stack(
          children: [
            _buildGallery(),
            IgnorePointer(
              ignoring: !_barsVisible,
              child: _buildTopBar(context),
            ),
            IgnorePointer(
              ignoring: !_barsVisible,
              child: _buildBottomBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGallery() {
    return PhotoViewGallery.builder(
      pageController: _pageController,
      itemCount: widget.imageUrls.length,
      onPageChanged: _onPageChanged,
      scrollPhysics: const BouncingScrollPhysics(),
      backgroundDecoration: const BoxDecoration(color: Colors.black),
      builder: (context, index) => PhotoViewGalleryPageOptions(
        imageProvider: CachedNetworkImageProvider(widget.imageUrls[index]),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3.0,
        // Hero matches the tag used by the tapped gallery card
        heroAttributes: index == widget.initialIndex
            ? PhotoViewHeroAttributes(tag: widget.heroTag)
            : null,
        errorBuilder: (_, _, _) => const Center(
          child: Icon(Icons.broken_image_rounded, color: Colors.white38, size: 64),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return AnimatedOpacity(
      opacity: _barsVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            
            height: 56,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    '${_currentIndex + 1} / ${widget.imageUrls.length}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                _ActionIconButton(
                  icon: Icons.save_alt_rounded,
                  loading: _saving,
                  onTap: _saveCurrentImage,
                ),
                _ActionIconButton(
                  icon: Icons.ios_share_rounded,
                  loading: _sharing,
                  onTap: _shareCurrentImage,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final caption = widget.imageCaptions[_currentUrl] ?? '';
    if (caption.isEmpty) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedOpacity(
        opacity: _barsVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black87],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 36),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              caption,
              key: ValueKey(_currentIndex),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Private button widget ─────────────────────────────────────────────────────

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final bool loading;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icon, color: Colors.white, size: 22),
      onPressed: loading ? null : onTap,
    );
  }
}
