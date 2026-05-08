import 'package:timeexplorer/features/event_explorer/domain/entities/event_category.dart';
import 'package:timeexplorer/features/event_explorer/domain/entities/historical_event.dart';

class EventModel extends HistoricalEvent {
  const EventModel({
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

  factory EventModel.fromMap(Map<String, dynamic> map, String id) {
    return EventModel(
      id: id,
      title: map['title'] ?? '',
      category: EventCategory.fromString(map['category'] ?? ''),
      period: map['period'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      timeline: (map['timeline'] as List? ?? [])
          .map((e) => TimelinePoint(
                date: e['date'] ?? '',
                description: e['description'] ?? '',
              ))
          .toList(),
      imageUrl: map['imageUrl'],
      importanceLevel: map['importanceLevel'] ?? 3,
      keyFacts: List<String>.from(map['keyFacts'] ?? []),
      galleryUrls: List<dynamic>.from(map['galleryUrls'] ?? []),
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      youtubeUrl: map['youtubeUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category.name,
      'period': period,
      'location': location,
      'description': description,
      'timeline': timeline
          .map((e) => {
                'date': e.date,
                'description': e.description,
              })
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
}
