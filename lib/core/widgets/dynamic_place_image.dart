import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeexplorer/core/services/pixabay_service.dart';
import 'package:timeexplorer/core/services/wikimedia_service.dart';
import 'package:timeexplorer/core/widgets/shimmer_box.dart';

class DynamicPlaceImage extends StatefulWidget {
  final String query;
  final String? fallbackUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const DynamicPlaceImage({
    super.key,
    required this.query,
    this.fallbackUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  State<DynamicPlaceImage> createState() => _DynamicPlaceImageState();
}

class _DynamicPlaceImageState extends State<DynamicPlaceImage> {
  final WikimediaService _wikimediaService = WikimediaService();
  final PixabayService _pixabayService = PixabayService();
  
  String? _imageUrl;
  bool _isLoading = true;
  bool _hasAttemptedFallback = false;

  @override
  void initState() {
    super.initState();
    _initImage();
  }

  void _initImage() {
    final hasFallback = widget.fallbackUrl != null && widget.fallbackUrl!.isNotEmpty;
    if (hasFallback) {
      _imageUrl = widget.fallbackUrl;
      _isLoading = false;
    } else {
      _isLoading = true;
      _loadImage();
    }
  }

  @override
  void didUpdateWidget(covariant DynamicPlaceImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query || oldWidget.fallbackUrl != widget.fallbackUrl) {
      _hasAttemptedFallback = false;
      _initImage();
    }
  }

  Future<void> _loadImage({bool isRetry = false}) async {
    if (!mounted) return;

    if (isRetry) {
      setState(() => _isLoading = true);
    }

    try {
      // 1. Try Wikimedia first
      String? url;
      try {
        url = await _wikimediaService
            .getImageUrl(widget.query)
            .timeout(const Duration(seconds: 8));
      } catch (_) {
        url = null;
      }

      // 2. If Wikimedia failed, try Pixabay
      if (url == null && mounted) {
        try {
          url = await _pixabayService
              .getImageUrl(widget.query)
              .timeout(const Duration(seconds: 8));
        } catch (_) {
          url = null;
        }
      }

      if (mounted) {
        setState(() {
          _imageUrl = url ?? widget.fallbackUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _imageUrl = widget.fallbackUrl;
          _isLoading = false;
        });
      }
    }
  }

  void _handleImageError() {
    if (!_hasAttemptedFallback && mounted) {
      _hasAttemptedFallback = true;
      // If the provided image failed, try to search for a new one
      _loadImage(isRetry: true);
    }
  }

  static const _iconColor = Color(0xFF8D7168);

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return ShimmerBox(width: widget.width, height: widget.height, radius: 0);
    }

    if (_imageUrl == null || _imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    return _buildCachedImage(_imageUrl!);
  }

  Widget _buildPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: const Color(0xFF151B26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_edu_rounded, color: _iconColor, size: 36),
          if (widget.height == null || widget.height! > 60) ...[
            const SizedBox(height: 6),
            const Text(
              'Legacy Image',
              style: TextStyle(color: _iconColor, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCachedImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      key: ValueKey(url),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      fadeInDuration: const Duration(milliseconds: 400),
      fadeInCurve: Curves.easeIn,
      httpHeaders: const {
        'User-Agent': 'TimeExplorer/1.0 (contact@example.com)',
        'Accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
      },
      memCacheWidth: (widget.width != null && widget.width!.isFinite)
          ? (widget.width! * 2).toInt()
          : 800,
      placeholder: (context, url) =>
          ShimmerBox(width: widget.width, height: widget.height, radius: 0),
      errorWidget: (context, url, error) {
        // Trigger fallback on error
        WidgetsBinding.instance.addPostFrameCallback((_) => _handleImageError());
        return _buildPlaceholder();
      },
    );
  }
}

