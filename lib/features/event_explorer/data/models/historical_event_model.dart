import '../../domain/entities/event_category.dart';
import '../../domain/entities/historical_event.dart';

class HistoricalEventModel extends HistoricalEvent {
  const HistoricalEventModel({
    required super.id,
    required super.title,
    required super.category,
    required super.period,
    required super.location,
    required super.description,
    required super.timeline,
    required super.imageUrl,
    required super.importanceLevel,
    required super.keyFacts,
    super.galleryUrls = const [],
    super.latitude,
    super.longitude,
    super.youtubeUrl,
  });

  factory HistoricalEventModel.fromMap(Map<String, dynamic> map) {
    return HistoricalEventModel(
      id: map['id'] as String,
      title: map['title'] as String,
      category: EventCategory.values.byName(map['category'] as String),
      period: map['period'] as String,
      location: map['location'] as String,
      description: map['description'] as String,
      timeline: (map['timeline'] as List)
          .map((t) => TimelinePoint(
                date: t['date'] as String,
                description: t['description'] as String,
              ))
          .toList(),
      imageUrl: map['imageUrl'], // Allow dynamic (String or List)
      importanceLevel: map['importanceLevel'] as int,
      keyFacts: List<String>.from(map['keyFacts'] as List),
      galleryUrls: map['galleryUrls'] != null
          ? List<dynamic>.from(map['galleryUrls'] as List)
          : const [],
      latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
      youtubeUrl: map['youtubeUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'category': category.name,
        'period': period,
        'location': location,
        'description': description,
        'timeline': timeline
            .map((t) => {'date': t.date, 'description': t.description})
            .toList(),
        'imageUrl': imageUrl,
        'importanceLevel': importanceLevel,
        'keyFacts': keyFacts,
        'galleryUrls': galleryUrls,
        'latitude': latitude,
        'longitude': longitude,
        'youtubeUrl': youtubeUrl,
      };
}
