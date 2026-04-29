// FILE: lib/features/places/presentation/widgets/place_image_gallery.dart
// PURPOSE: Auto-scrolling PageView gallery with dot indicator and full-screen viewer.
// SPRINT: 3 — TASK 3.2

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeexplorer/core/widgets/shimmer_box.dart';

class PlaceImageGallery extends StatefulWidget {
  final String placeId;
  final List<String> imageUrls;

  const PlaceImageGallery({
    super.key,
    required this.placeId,
    required this.imageUrls,
  });

  @override
  State<PlaceImageGallery> createState() => _PlaceImageGalleryState();
}

class _PlaceImageGalleryState extends State<PlaceImageGallery> {
  late final PageController _controller;
  Timer? _autoScroll;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScroll?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScroll?.cancel();
    _autoScroll = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || widget.imageUrls.length <= 1) return;
      final next = (_current + 1) % widget.imageUrls.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _pauseAndResume() {
    _autoScroll?.cancel();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _startAutoScroll();
    });
  }

  void _openFullScreen(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenGallery(
          imageUrls: widget.imageUrls,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.imageUrls;
    if (urls.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: GestureDetector(
            onPanDown: (_) => _pauseAndResume(),
            child: PageView.builder(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              itemCount: urls.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (context, index) {
                final isFirst = index == 0;
                final image = CachedNetworkImage(
                  imageUrl: urls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (_, _) => ShimmerBox(height: 220, radius: 0),
                  errorWidget: (_, _, _) => Container(
                    color: const Color(0xFF1A1A2E),
                    child: const Icon(Icons.image_not_supported_rounded,
                        color: Colors.white38, size: 40),
                  ),
                );
                return GestureDetector(
                  onTap: () => _openFullScreen(context, index),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: isFirst
                        ? Hero(
                            tag: 'place-hero-${widget.placeId}',
                            child: image,
                          )
                        : image,
                  ),
                );
              },
            ),
          ),
        ),
        if (urls.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              urls.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _current == i ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _current == i
                      ? const Color(0xFF6C63FF)
                      : Colors.grey[400],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _FullScreenGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const _FullScreenGallery({
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_current + 1} / ${widget.imageUrls.length}',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: widget.initialIndex),
        itemCount: widget.imageUrls.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (_, index) => InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: widget.imageUrls[index],
            fit: BoxFit.contain,
            errorWidget: (_, _, _) => const Icon(Icons.broken_image,
                color: Colors.white38, size: 60),
          ),
        ),
      ),
    );
  }
}
