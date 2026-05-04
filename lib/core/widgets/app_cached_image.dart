import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

String _safeUrl(String url) {
  try {
    return Uri.encodeFull(Uri.decodeFull(url));
  } catch (_) {
    return url;
  }
}

class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Color? backgroundColor;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? const Color(0xFFF3F4F6); // Soft gray fallback

    Widget imageContent;

    if (imageUrl.isEmpty) {
      imageContent = _buildErrorFallback(bgColor);
    } else {
      final encodedUrl = _safeUrl(imageUrl);
      imageContent = CachedNetworkImage(
        imageUrl: encodedUrl,
        key: ValueKey(encodedUrl),
        width: width,
        height: height,
        fit: fit,
        httpHeaders: const {
          'User-Agent': 'TimeExplorer/1.0 (Flutter)',
          'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
        },
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: bgColor,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildErrorFallback(bgColor),
      );
    }

    if (borderRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: imageContent,
      );
    }

    return imageContent;
  }

  Widget _buildErrorFallback(Color bgColor) {
    return Container(
      width: width,
      height: height,
      color: bgColor,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }
}
