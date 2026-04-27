import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeexplorer/core/services/pixabay_service.dart';
import 'package:timeexplorer/core/services/wikimedia_service.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

class PlaceImageGallery extends StatefulWidget {
  final String query;
  final String? fallbackUrl;
  final double height;

  const PlaceImageGallery({
    super.key,
    required this.query,
    this.fallbackUrl,
    required this.height,
  });

  @override
  State<PlaceImageGallery> createState() => _PlaceImageGalleryState();
}

class _PlaceImageGalleryState extends State<PlaceImageGallery> {
  final WikimediaService _wikimediaService = WikimediaService();
  final PixabayService _pixabayService = PixabayService();
  
  List<String> _imageUrls = [];
  bool _isLoading = true;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Show fallbackUrl immediately while API images load
    if (widget.fallbackUrl != null && widget.fallbackUrl!.isNotEmpty) {
      _imageUrls = [widget.fallbackUrl!];
      _isLoading = false;
    }
    _loadImages();
  }

  Future<void> _loadImages() async {
    if (!mounted) return;

    try {
      List<String> urls = [];

      // 1. Fetch from Pixabay (with timeout)
      try {
        final pixabayUrls = await _pixabayService
            .getImageUrls(widget.query, limit: 4)
            .timeout(const Duration(seconds: 6));
        urls.addAll(pixabayUrls);
      } catch (e) {
        debugPrint('PlaceImageGallery: Pixabay error: $e');
      }

      // 2. If we have few images, try Wikimedia (with timeout)
      if (urls.length < 3) {
        try {
          final wikiUrl = await _wikimediaService
              .getImageUrl(widget.query)
              .timeout(const Duration(seconds: 5));
          if (wikiUrl != null && wikiUrl.isNotEmpty) {
            urls.add(wikiUrl);
          }
        } catch (e) {
          debugPrint('PlaceImageGallery: Wikimedia error: $e');
        }
      }

      // 3. Add fallback if available and not already in list
      if (widget.fallbackUrl != null && widget.fallbackUrl!.isNotEmpty) {
        if (!urls.contains(widget.fallbackUrl)) {
          urls.insert(0, widget.fallbackUrl!); // Put fallback first for fastest display
        }
      }

      // 4. Remove duplicates and empty strings
      urls = urls.where((u) => u.isNotEmpty).toSet().toList();

      if (mounted) {
        setState(() {
          _imageUrls = urls;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('PlaceImageGallery: Critical error loading images: $e');
      if (mounted) {
        setState(() {
          if (widget.fallbackUrl != null && widget.fallbackUrl!.isNotEmpty) {
            _imageUrls = [widget.fallbackUrl!];
          }
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: widget.height,
        color: AppTheme.surfaceLow,
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryContainer),
        ),
      );
    }

    if (_imageUrls.isEmpty) {
      return Container(
        height: widget.height,
        color: AppTheme.surfaceLow,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_edu_rounded, size: 50, color: Color(0xFF8D7168)),
            SizedBox(height: 8),
            Text(
              'Historical Image',
              style: TextStyle(color: Color(0xFF8D7168), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: _imageUrls[index],
                fit: BoxFit.cover,
                httpHeaders: const {
                  'User-Agent': 'TimeExplorer/1.0 (contact@example.com)',
                  'Accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
                },
                placeholder: (context, url) => const ColoredBox(
                  color: AppTheme.surfaceLow,
                  child: Center(
                    child: CircularProgressIndicator(color: AppTheme.primaryContainer),
                  ),
                ),
                errorWidget: (context, url, error) => const ColoredBox(
                  color: AppTheme.surfaceLow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_edu_rounded, color: Color(0xFF8D7168), size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Historical Image',
                        style: TextStyle(color: Color(0xFF8D7168), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (_imageUrls.length > 1) ...[
          // Left Arrow
          if (_currentPage > 0)
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            ),
          // Right Arrow
          if (_currentPage < _imageUrls.length - 1)
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            ),
          // Indicators
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _imageUrls.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
