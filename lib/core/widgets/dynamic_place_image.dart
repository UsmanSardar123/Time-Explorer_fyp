import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeexplorer/core/services/place_image_repository.dart';
import 'package:timeexplorer/core/widgets/shimmer_box.dart';

/// A smart image widget for place covers that:
///   • Shows [fallbackUrl] instantly when it is available (zero delay).
///   • Otherwise resolves via [PlaceImageRepository] (memory → SharedPreferences
///     → Wikimedia → Pixabay) and persists the result so future loads are
///     instantaneous.
///   • When [placeId] is provided, resolution results are persisted between
///     app sessions. Pass it whenever you have the place ID.
///   • Falls back to a beautiful monument placeholder — never shows
///     broken images or raw error icons.
class DynamicPlaceImage extends StatefulWidget {
  final String query;

  /// Firestore document ID of the place. Required for persistent caching.
  final String? placeId;

  /// Pre-fetched image URL (e.g. from Firestore). Shown immediately while
  /// background resolution completes.
  final String? fallbackUrl;

  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const DynamicPlaceImage({
    super.key,
    required this.query,
    this.placeId,
    this.fallbackUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  State<DynamicPlaceImage> createState() => _DynamicPlaceImageState();
}

class _DynamicPlaceImageState extends State<DynamicPlaceImage> {
  String? _imageUrl;
  bool _isLoading = true;
  bool _isRetry = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant DynamicPlaceImage old) {
    super.didUpdateWidget(old);
    if (old.query != widget.query ||
        old.placeId != widget.placeId ||
        old.fallbackUrl != widget.fallbackUrl) {
      _init();
    }
  }

  void _init() {
    _isRetry = false;
    // Show the stored URL immediately — no shimmer, no wait.
    if (widget.fallbackUrl != null && widget.fallbackUrl!.isNotEmpty) {
      setState(() {
        _imageUrl = widget.fallbackUrl;
        _isLoading = false;
      });
    } else {
      setState(() {
        _imageUrl = null;
        _isLoading = true;
      });
      _resolve();
    }
  }

  Future<void> _resolve() async {
    String? url;

    if (widget.placeId != null) {
      url = await PlaceImageRepository.instance.resolve(
        placeId: widget.placeId!,
        placeName: widget.query,
        storedUrl: widget.fallbackUrl,
        forceRefresh: _isRetry,
      );
    } else {
      // No placeId — use in-memory services directly (no persistence).
      url = await PlaceImageRepository.instance.resolve(
        placeId: widget.query, // use query as surrogate key
        placeName: widget.query,
        storedUrl: widget.fallbackUrl,
        forceRefresh: _isRetry,
      );
    }

    if (mounted) {
      setState(() {
        _imageUrl = url;
        _isLoading = false;
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_isLoading) {
      child = ShimmerBox(width: widget.width, height: widget.height, radius: 0);
    } else if (_imageUrl == null || _imageUrl!.isEmpty) {
      child = _Placeholder(width: widget.width, height: widget.height);
    } else {
      child = _CachedImage(
        url: _imageUrl!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        onError: _onImageError,
      );
    }

    if (widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: child);
    }
    return child;
  }

  void _onImageError() {
    if (!mounted) return;
    
    // Prevent infinite loop if the resolved URL from repository also fails
    if (_isRetry) {
      setState(() {
        _imageUrl = null;
        _isLoading = false; // Stop loading and show fallback placeholder
      });
      return;
    }

    // Image URL was bad — clear from caches and try a fresh fetch.
    if (widget.placeId != null) {
      PlaceImageRepository.instance.evict(widget.placeId!);
    }
    setState(() {
      _imageUrl = null;
      _isLoading = true;
      _isRetry = true;
    });
    _resolve();
  }
}

// ── URL helpers ───────────────────────────────────────────────────────────────

/// Normalises a URL so non-ASCII path characters are percent-encoded without
/// double-encoding sequences that are already encoded.
String _safeUrl(String url) {
  try {
    return Uri.encodeFull(Uri.decodeFull(url));
  } catch (_) {
    return url;
  }
}

// ── Extracted sub-widgets (keeps the state class lean) ───────────────────────

class _CachedImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final VoidCallback onError;

  const _CachedImage({
    required this.url,
    required this.width,
    required this.height,
    required this.fit,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    final encodedUrl = _safeUrl(url);
    return CachedNetworkImage(
      imageUrl: encodedUrl,
      key: ValueKey(encodedUrl),
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 350),
      fadeInCurve: Curves.easeIn,
      httpHeaders: const {
        'User-Agent': 'TimeExplorer/1.0',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
      },
      memCacheWidth: (width != null && width!.isFinite)
          ? (width! * 2).toInt()
          : 800,
      placeholder: (context, url) =>
          ShimmerBox(width: width, height: height, radius: 0),
      errorWidget: (context, url, error) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => onError());
        return _Placeholder(width: width, height: height);
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  final double? width;
  final double? height;

  const _Placeholder({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2332), Color(0xFF0F1923)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_rounded,
            color: Colors.white.withValues(alpha: 0.25),
            size: (height != null && height! > 80) ? 40 : 22,
          ),
          if (height == null || height! > 80) ...[
            const SizedBox(height: 8),
            Text(
              'No Image Available',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
