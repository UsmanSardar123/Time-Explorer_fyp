import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';

class PlaceModel extends PlaceEntity {
  const PlaceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.category,
    required super.rating,
    required super.location,
    super.history,
    super.era,
    super.quickFacts,
    super.galleryImages,
    super.audioUrl,
    super.builtBy,
    super.yearBuilt,
    super.civilization,
    super.funFacts = const [],
    super.timeline = const [],
    super.averageRating = 0.0,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json, String id) {
    return PlaceModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      location: json['location'] ?? '',
      history: json['history'],
      era: json['era'],
      quickFacts: json['quickFacts'] != null
          ? Map<String, String>.from(json['quickFacts'])
          : null,
      galleryImages: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
      audioUrl: json['audioUrl'],
      builtBy: json['builtBy'],
      yearBuilt: json['yearBuilt'],
      civilization: json['civilization'],
      funFacts: json['funFacts'] != null
          ? List<String>.from(json['funFacts'])
          : const [],
      timeline: json['timeline'] != null
          ? List<Map<String, String>>.from(
              (json['timeline'] as List).map(
                (e) => Map<String, String>.from(e as Map),
              ),
            )
          : const [],
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'location': location,
      'history': history,
      'era': era,
      'quickFacts': quickFacts,
      'images': galleryImages,
      'audioUrl': audioUrl,
      'builtBy': builtBy,
      'yearBuilt': yearBuilt,
      'civilization': civilization,
      'funFacts': funFacts,
      'timeline': timeline,
      'averageRating': averageRating,
    };
  }
}
