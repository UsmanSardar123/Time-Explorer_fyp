import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeexplorer/core/services/pixabay_service.dart';

class PixabayImage extends StatefulWidget {
  final String query;
  final String? fallbackUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const PixabayImage({
    super.key,
    required this.query,
    this.fallbackUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  State<PixabayImage> createState() => _PixabayImageState();
}

class _PixabayImageState extends State<PixabayImage> {
  final PixabayService _service = PixabayService();
  String? _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant PixabayImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
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
      // But prioritize Pixabay for better quality if possible, or use fallback as placeholder?
      // Actually, let's try Pixabay first.
      
      final url = await _service.getImageUrl(widget.query);
      
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
      // Pixabay images don't need special User-Agent headers usually, but good to keep standard
      memCacheWidth: (widget.width != null && widget.width!.isFinite) ? (widget.width! * 2).toInt() : 800,
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
