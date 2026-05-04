// FILE: lib/features/places/presentation/pages/place_image_viewer_screen.dart
// PURPOSE: Full-screen pinch-to-zoom gallery viewer with caption overlay and share.
// FEATURE: Photo Gallery

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<void> _shareCurrentImage() async {
    setState(() => _sharing = true);
    try {
      final file = await DefaultCacheManager().getSingleFile(_currentUrl);
      await Share.shareXFiles([XFile(file.path)]);
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

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
      backgroundDecoration: const BoxDecoration(color: Colors.black),
      builder: (context, index) => PhotoViewGalleryPageOptions(
        imageProvider: CachedNetworkImageProvider(widget.imageUrls[index]),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2.5,
        heroAttributes: index == 0
            ? PhotoViewHeroAttributes(tag: widget.heroTag)
            : null,
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return AnimatedOpacity(
      opacity: _barsVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        height: 80 + MediaQuery.of(context).padding.top,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black54, Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Text(
                  '${_currentIndex + 1} / ${widget.imageUrls.length}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: _sharing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.share, color: Colors.white),
                onPressed: _sharing ? null : _shareCurrentImage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final caption = widget.imageCaptions[_currentUrl] ?? '';
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
              colors: [Colors.transparent, Colors.black54],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
