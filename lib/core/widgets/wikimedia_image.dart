import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeexplorer/core/services/wikimedia_service.dart';

class WikimediaImage extends StatefulWidget {
  final String placeName;
  final String? fallbackUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const WikimediaImage({
    super.key,
    required this.placeName,
    this.fallbackUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  State<WikimediaImage> createState() => _WikimediaImageState();
}

class _WikimediaImageState extends State<WikimediaImage> {
  final WikimediaService _service = WikimediaService();
  String? _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant WikimediaImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.placeName != widget.placeName) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // First check if we have a valid fallback URL (from Firestore seeding)
      // If it's a wikipedia commons URL, we can use it directly or try to get a better one
      // For now, let's prioritize the API result to ensure high quality

      final url = await _service.getImageUrl(widget.placeName);

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[200],
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_imageUrl == null || _imageUrl!.isEmpty) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    return CachedNetworkImage(
      imageUrl: _imageUrl!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      httpHeaders: const {
        'User-Agent': 'TimeExplorer/1.0 (contact@example.com)',
      },
      memCacheWidth: (widget.width != null && widget.width!.isFinite)
          ? (widget.width! * 2).toInt()
          : 800, // Optimize memory
      placeholder: (context, url) => Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[200],
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }
}
