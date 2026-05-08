import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../features/event_explorer/domain/entities/event_category.dart';

/// A universal, resilient image loading widget used throughout the Event module.
///
/// Supports multi-tiered sequential fallback:
///   Tier 1 – Primary URL(s) from the event data
///   Tier 2 – Unsplash dynamic search image (if [category] is supplied)
///   Tier 3 – Category-specific local placeholder asset
///   Tier 4 – Themed icon + text error state (always non-null)
///
/// Pass [heroTag] to wrap the result in a [Hero] widget.
/// The [borderRadius] is applied uniformly via [ClipRRect].
class AppImageLoader extends StatefulWidget {
  /// Raw image source — String or List<String> of prioritised URLs.
  final dynamic imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double borderRadius;
  final Map<String, String>? headers;

  /// Unique Hero tag. Use `event.heroTag` from the model for consistency.
  final String? heroTag;

  /// Override the final error state widget (all fallbacks exhausted).
  final Widget? errorWidget;

  /// Supplies keyword + icon + colour for Tier 2/3 fallbacks.
  final EventCategory? category;

  const AppImageLoader({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.headers,
    this.heroTag,
    this.errorWidget,
    this.category,
  });

  @override
  State<AppImageLoader> createState() => _AppImageLoaderState();
}

class _AppImageLoaderState extends State<AppImageLoader> {
  late List<String> _urls;
  int _currentIndex = 0;
  bool _hasFailedAll = false;

  @override
  void initState() {
    super.initState();
    _initUrls();
  }

  @override
  void didUpdateWidget(AppImageLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl ||
        oldWidget.category != widget.category) {
      setState(() {
        _currentIndex = 0;
        _hasFailedAll = false;
      });
      _initUrls();
    }
  }

  void _initUrls() {
    final sources = <String>[];

    // ── Tier 1: Configured primary sources ──────────────────────────────────
    if (widget.imageUrl is String) {
      final s = (widget.imageUrl as String).trim();
      if (s.isNotEmpty) sources.add(s);
    } else if (widget.imageUrl is List) {
      for (final item in (widget.imageUrl as List)) {
        final s = item.toString().trim();
        if (s.isNotEmpty && !sources.contains(s)) sources.add(s);
      }
    }

    // ── Tier 2: Unsplash dynamic keyword search ──────────────────────────────
    if (widget.category != null) {
      const url = 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4'
          '?auto=format&fit=crop&w=800&q=80';
      if (!sources.contains(url)) sources.add(url);

      // ── Tier 3: Local category asset ──────────────────────────────────────
      final asset = 'assets/images/events/placeholder_${widget.category!.name}.png';
      if (!sources.contains(asset)) sources.add(asset);
    }

    _urls = sources;
    _currentIndex = 0;
    _hasFailedAll = sources.isEmpty;
    if (mounted) setState(() {});
  }

  void _handleError() {
    if (!mounted) return;
    if (_currentIndex < _urls.length - 1) {
      setState(() => _currentIndex++);
    } else {
      setState(() => _hasFailedAll = true);
    }
  }

  bool _isAsset(String url) =>
      url.isNotEmpty && !url.startsWith('http') && !url.startsWith('//');

  String _normalizeUrl(String url) {
    final t = url.trim();
    if (t.startsWith('//')) return 'https:$t';
    if (t.startsWith('http://')) return t.replaceFirst('http://', 'https://');
    return t;
  }

  @override
  Widget build(BuildContext context) {
    if (_hasFailedAll || _urls.isEmpty) {
      return widget.errorWidget ?? _buildErrorPlaceholder();
    }

    final currentUrl = _urls[_currentIndex];
    Widget image;

    if (_isAsset(currentUrl)) {
      // ── Local asset ────────────────────────────────────────────────────────
      image = Image.asset(
        currentUrl,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        errorBuilder: (_, __, ___) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _handleError());
          return _buildLoading();
        },
      );
    } else {
      final normalizedUrl = _normalizeUrl(currentUrl);

      if (kIsWeb) {
        // ── Web: Image.network (CachedNetworkImage not supported on web) ──────
        image = Image.network(
          normalizedUrl,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          errorBuilder: (_, __, ___) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _handleError());
            return _buildLoading();
          },
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : _buildLoading(),
        );
      } else {
        // ── Mobile: CachedNetworkImage ─────────────────────────────────────
        final isWikimedia = normalizedUrl.contains('wikimedia.org');
        image = CachedNetworkImage(
          imageUrl: normalizedUrl,
          httpHeaders: isWikimedia ? widget.headers : null,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          placeholder: (_, __) => _buildLoading(),
          errorWidget: (_, __, ___) {
            // Silently rotate to the next fallback without crashing the UI.
            WidgetsBinding.instance.addPostFrameCallback((_) => _handleError());
            return _buildLoading();
          },
        );
      }
    }

    // ── Apply border radius ──────────────────────────────────────────────────
    if (widget.borderRadius > 0) {
      image = ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: image,
      );
    }

    // ── Wrap in Hero if tag provided ─────────────────────────────────────────
    if (widget.heroTag != null) {
      image = Hero(tag: widget.heroTag!, child: image);
    }

    return image;
  }

  // ── Placeholder builders ─────────────────────────────────────────────────

  Widget _buildLoading() => SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );

  Widget _buildErrorPlaceholder() {
    final accent = widget.category?.color ?? Colors.grey;
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.category?.icon ?? Icons.broken_image_rounded,
              color: accent.withValues(alpha: 0.5),
              size: (widget.width != null && widget.width! < 100) ? 24 : 42,
            ),
            if (widget.width == null || widget.width! > 100) ...[
              const SizedBox(height: 8),
              Text(
                'Visual Unavailable',
                style: TextStyle(
                  color: accent.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
