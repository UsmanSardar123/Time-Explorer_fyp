// FILE: lib/features/places/presentation/widgets/place_gallery_widget.dart
// PURPOSE: Auto-playing image gallery with Wikimedia fetch, thumbnail strip, and full-screen entry.
// FEATURE: Photo Gallery

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
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 4), _startAutoPlay);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) return _buildShimmerPlaceholder();
    if (_effectiveUrls.isEmpty) return _buildEmptyPlaceholder();
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

  Widget _buildShimmerPlaceholder() {
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

  Widget _buildEmptyPlaceholder() {
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
            Icon(Icons.image_not_supported_outlined,
                size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('No images available',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
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
              itemBuilder: (_, index) => _buildPage(index),
            ),
            _buildBadge(),
            _buildExpandButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    final image = CachedNetworkImage(
      imageUrl: _effectiveUrls[index],
      fit: BoxFit.cover,
      width: double.infinity,
      height: 280,
      placeholder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(color: Colors.white),
      ),
      errorWidget: (_, __, ___) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported,
            color: Colors.grey, size: 40),
      ),
    );
    return index == 0 ? Hero(tag: widget.heroTag, child: image) : image;
  }

  Widget _buildBadge() {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${_currentIndex + 1} / ${_effectiveUrls.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandButton(BuildContext context) {
    return Positioned(
      top: 4,
      left: 4,
      child: IconButton(
        icon: const Icon(Icons.fullscreen, color: Colors.white, size: 28),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PlaceImageViewerScreen(
              imageUrls: _effectiveUrls,
              imageCaptions: widget.imageCaptions,
              initialIndex: _currentIndex,
              heroTag: widget.heroTag,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailStrip() {
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: _effectiveUrls.length,
        itemBuilder: (_, index) => _buildThumbnail(index),
      ),
    );
  }

  Widget _buildThumbnail(int index) {
    final isActive = index == _currentIndex;
    return GestureDetector(
      onTap: () => _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? widget.accentColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: _effectiveUrls[index],
            fit: BoxFit.cover,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(color: Colors.white),
            ),
            errorWidget: (_, __, ___) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported,
                  size: 20, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
