import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'event_category.dart';

part 'historical_event.g.dart';

@HiveType(typeId: 21)
class TimelinePoint {
  @HiveField(0)
  final String date;
  @HiveField(1)
  final String description;
  const TimelinePoint({required this.date, required this.description});
}

// ── Stable Unsplash fallback ─────────────────────────────────────────────────

/// Returns a guaranteed, stable Unsplash URL.
/// This is the universal last-resort fallback for the entire Event module.
String _unsplashFallback() =>
    'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop&w=800&q=80';

// ── Domain Entity ────────────────────────────────────────────────────────────

@HiveType(typeId: 22)
class HistoricalEvent extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final EventCategory category;
  @HiveField(3)
  final String period;
  @HiveField(4)
  final String location;
  @HiveField(5)
  final String description;
  @HiveField(6)
  final List<TimelinePoint> timeline;

  /// Raw image source — can be a single URL String or a List<String> of
  /// prioritised fallback URLs. Always consume via [heroImageUrl] in the UI.
  @HiveField(7)
  final dynamic imageUrl;

  @HiveField(8)
  final int importanceLevel; // 1–5
  @HiveField(9)
  final List<String> keyFacts;

  /// Additional gallery sources. Each entry may itself be a String or List<String>.
  @HiveField(10)
  final List<dynamic> galleryUrls;

  @HiveField(11)
  final double? latitude;
  
  @HiveField(12)
  final double? longitude;
  
  @HiveField(13)
  final String? youtubeUrl;

  const HistoricalEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.period,
    required this.location,
    required this.description,
    required this.timeline,
    required this.imageUrl,
    required this.importanceLevel,
    required this.keyFacts,
    this.galleryUrls = const [],
    this.latitude,
    this.longitude,
    this.youtubeUrl,
  });

  // ── Hero ─────────────────────────────────────────────────────────────────

  /// Primary display URL for the hero / card image.
  /// GUARANTEED non-empty — falls back to a curated Unsplash photo if every
  /// configured source is missing or blank.
  String get heroImageUrl {
    final url = _firstString(imageUrl);
    return url.isNotEmpty ? url : _unsplashFallback();
  }

  /// Unique Hero animation tag.  Uses `hero_<id>` so it is always distinct
  /// across all screens, preventing Hero-tag collision crashes.
  String get heroTag => 'hero_$id';

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Extracts the first non-empty string from a dynamic value (String or List).
  static String _firstString(dynamic src) {
    if (src is String) return src.trim();
    if (src is List && src.isNotEmpty) return src.first.toString().trim();
    return '';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        period,
        location,
        latitude,
        longitude,
        youtubeUrl,
      ];
}
