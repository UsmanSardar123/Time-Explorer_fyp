import 'package:equatable/equatable.dart';

class PlaceEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final double rating;
  final String location;
  final String? history;
  final String? era;
  final Map<String, String>? quickFacts;
  final List<String>? galleryImages;
  final String? audioUrl;
  final String? builtBy;
  final String? yearBuilt;
  final String? civilization;
  final String? buildType;
  final String? historicalPeriod;
  final String? primaryMaterial;
  final String? dimensions;
  final String? unescoStatus;
  final String? purpose;
  final List<String> funFacts;
  final List<Map<String, String>> timeline;
  final double averageRating;

  const PlaceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.location,
    this.history,
    this.era,
    this.quickFacts,
    this.galleryImages,
    this.audioUrl,
    this.builtBy,
    this.yearBuilt,
    this.civilization,
    this.buildType,
    this.historicalPeriod,
    this.primaryMaterial,
    this.dimensions,
    this.unescoStatus,
    this.purpose,
    this.funFacts = const [],
    this.timeline = const [],
    this.averageRating = 0.0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        category,
        rating,
        location,
        history,
        era,
        quickFacts,
        galleryImages,
        audioUrl,
        builtBy,
        yearBuilt,
        civilization,
        buildType,
        historicalPeriod,
        primaryMaterial,
        dimensions,
        unescoStatus,
        purpose,
        funFacts,
        timeline,
        averageRating,
      ];
}
