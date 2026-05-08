import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeexplorer/features/places/data/services/place_image_service.dart';
import 'package:timeexplorer/features/places/presentation/pages/place_image_viewer_screen.dart';

class PlaceGalleryWidget extends StatefulWidget {
  final List<String> imageUrls;
  final Map<String, String> imageCaptions;
  final String heroTag;
  final Color accentColor;
  final String? placeName;

  const PlaceGalleryWidget({
    super.key,
    required this.imageUrls,
    required this.imageCaptions,
    required this.heroTag,
    required this.accentColor,
    this.placeName,
  });

  @override
  State<PlaceGalleryWidget> createState() => _PlaceGalleryWidgetState();
}

class _PlaceGalleryWidgetState extends State<PlaceGalleryWidget> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;
  List<String> _fetchedUrls = [];
  bool _isFetching = false;

  List<String> get _effectiveUrls =>
      widget.imageUrls.isNotEmpty ? widget.imageUrls : _fetchedUrls;

  // Per-image hero tag so any page can animate into the viewer
  String _heroTag(int index) => '${widget.heroTag}_$index';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.imageUrls.isEmpty && widget.placeName != null) {
      _fetchImages();
    } else if (widget.imageUrls.length > 1) {
      _startAutoPlay();
    }
  }

  Future<void> _fetchImages() async {
    setState(() => _isFetching = true);
    try {
      final urls = await PlaceImageService.fetchImages(widget.placeName!);
      if (!mounted) return;
      setState(() {
        _fetchedUrls = urls;
        _isFetching = false;
      });
      if (_fetchedUrls.length > 1) _startAutoPlay();
    } catch (_) {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final next = (_currentIndex + 1) % _effectiveUrls.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 4), _startAutoPlay);
  }

  void _openViewer(BuildContext context, int index) {
    _timer?.cancel();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, _, _) => PlaceImageViewerScreen(
          imageUrls: _effectiveUrls,
          imageCaptions: widget.imageCaptions,
          initialIndex: index,
          heroTag: _heroTag(index),
        ),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
          child: child,
        ),
      ),
    ).then((_) {
      // Resume autoplay when returning from viewer
      if (mounted && _effectiveUrls.length > 1) _startAutoPlay();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isFetching) return _buildShimmer();
    if (_effectiveUrls.isEmpty) return _buildEmptyState();

    return Column(
      children: [
        _buildPageView(context),
        if (_effectiveUrls.length > 1) ...[
          const SizedBox(height: 10),
          _buildThumbnailStrip(),
        ],
      ],
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_library_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No photos available for this place',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _effectiveUrls.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (ctx, index) => _buildPage(ctx, index),
            ),
            // Counter badge — top right
            _buildCountBadge(),
            // Fullscreen hint — top left
            const Positioned(
              top: 10,
              left: 10,
              child: Icon(
                Icons.zoom_out_map_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _openViewer(context, index),
      child: Hero(
        tag: _heroTag(index),
        child: CachedNetworkImage(
          imageUrl: _effectiveUrls[index],
          fit: BoxFit.cover,
          width: double.infinity,
          height: 280,
          placeholder: (_, _) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(color: Colors.white),
          ),
          errorWidget: (_, _, _) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image_rounded,
                color: Colors.grey, size: 40),
          ),
        ),
      ),
    );
  }

  Widget _buildCountBadge() {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '${_currentIndex + 1} / ${_effectiveUrls.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailStrip() {
    return SizedBox(
      height: 68,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: _effectiveUrls.length,
        itemBuilder: (ctx, index) => _buildThumbnail(ctx, index),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, int index) {
    final isActive = index == _currentIndex;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? widget.accentColor : Colors.transparent,
            width: 2.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: _effectiveUrls[index],
            fit: BoxFit.cover,
            placeholder: (_, _) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(color: Colors.white),
            ),
            errorWidget: (_, _, _) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image_rounded,
                  size: 18, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
