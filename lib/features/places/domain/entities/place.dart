import 'package:equatable/equatable.dart';
import 'timeline_event.dart';
import 'package:timeexplorer/models/place_era.dart';

class PlaceQuiz extends Equatable {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  const PlaceQuiz({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  @override
  List<Object?> get props => [question, options, correctAnswerIndex];

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }

  factory PlaceQuiz.fromMap(Map<String, dynamic> map) {
    return PlaceQuiz(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
    );
  }
}

class Place extends Equatable {
  final String id;
  final String name;
  final String category;
  final String location;
  final String description;
  final String imageUrl; // Cover image
  final String? eraId;
  final String? history;
  final String? country;
  final String? civilization;
  final String? builtBy;
  final String? constructionDate;
  final String? architecturalStyle;
  final String? historicalSignificance;
  // Scraper-sourced decathlon fields
  final String? buildType;
  final String? historicalPeriod;
  final String? primaryMaterial;
  final String? dimensions;
  final String? unescoStatus;
  final String? purpose;
  final List<String>? funFacts;
  final String? visitorInfo;
  final String? createdAt;
  final List<String>? wikimediaTags;
  final List<String>? images;
  final List<String>? keyFacts;
  final String? openingHours;
  final String? ticketPrice;
  final String? bestTimeToVisit;
  final String? visitDuration;
  final String? didYouKnow;
  final double? latitude;
  final double? longitude;
  final double rating;

  // Sprint 1 Additions
  final String? era; // Kept for backwards compatibility
  final PlaceEra? eraEnum;
  final String? eraLabel;
  final String? city;
  final String? significance;
  final List<String>? facts;
  final List<TimelineEvent>? timeline;

  // Sprint 6 Addition
  final List<PlaceQuiz>? quizzes;

  // Sprint 1 — Ask the Guide bridge + UI metadata
  final List<String>? associatedCharacterIds;
  final String? colorThemeHex;
  final List<String>? nearbyPlaceIds;
  final String? aiInsightsCacheKey;

  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.description,
    required this.imageUrl,
    this.eraId,
    this.history,
    this.country,
    this.civilization,
    this.builtBy,
    this.constructionDate,
    this.architecturalStyle,
    this.historicalSignificance,
    this.buildType,
    this.historicalPeriod,
    this.primaryMaterial,
    this.dimensions,
    this.unescoStatus,
    this.purpose,
    this.funFacts,
    this.visitorInfo,
    this.createdAt,
    this.wikimediaTags,
    this.images,
    this.keyFacts,
    this.openingHours,
    this.ticketPrice,
    this.bestTimeToVisit,
    this.visitDuration,
    this.didYouKnow,
    this.latitude,
    this.longitude,
    required this.rating,
    this.era,
    this.eraEnum,
    this.eraLabel,
    this.city,
    this.significance,
    this.facts,
    this.timeline,
    this.quizzes,
    this.associatedCharacterIds,
    this.colorThemeHex,
    this.nearbyPlaceIds,
    this.aiInsightsCacheKey,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        location,
        description,
        imageUrl,
        eraId,
        history,
        country,
        civilization,
        builtBy,
        constructionDate,
        architecturalStyle,
        historicalSignificance,
        buildType,
        historicalPeriod,
        primaryMaterial,
        dimensions,
        unescoStatus,
        purpose,
        funFacts,
        visitorInfo,
        createdAt,
        wikimediaTags,
        images,
        keyFacts,
        openingHours,
        ticketPrice,
        bestTimeToVisit,
        visitDuration,
        didYouKnow,
        latitude,
        longitude,
        rating,
        era,
        eraEnum,
        eraLabel,
        city,
        significance,
        facts,
        timeline,
        quizzes,
        associatedCharacterIds,
        colorThemeHex,
        nearbyPlaceIds,
        aiInsightsCacheKey,
      ];
}
