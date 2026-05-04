import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import '../../domain/entities/timeline_event.dart';
import 'package:timeexplorer/models/place_era.dart';

class PlaceModel extends Place {
  const PlaceModel({
    required super.id,
    required super.name,
    required super.category,
    required super.location,
    required super.description,
    required super.imageUrl,
    super.eraId,
    super.history,
    super.country,
    super.civilization,
    super.builtBy,
    super.constructionDate,
    super.architecturalStyle,
    super.historicalSignificance,
    super.buildType,
    super.historicalPeriod,
    super.primaryMaterial,
    super.dimensions,
    super.unescoStatus,
    super.purpose,
    super.funFacts,
    super.visitorInfo,
    super.createdAt,
    super.wikimediaTags,
    super.images,
    super.imageUrls = const [],
    super.imageCaptions = const {},
    super.keyFacts,
    super.openingHours,
    super.ticketPrice,
    super.bestTimeToVisit,
    super.visitDuration,
    super.didYouKnow,
    super.latitude,
    super.longitude,
    required super.rating,
    super.era,
    super.eraEnum,
    super.eraLabel,
    super.city,
    super.significance,
    super.facts,
    super.timeline,
    super.quizzes,
    super.associatedCharacterIds,
    super.colorThemeHex,
    super.nearbyPlaceIds,
    super.aiInsightsCacheKey,
  });

  factory PlaceModel.fromMap(Map<String, dynamic> data, String id) {
    return PlaceModel(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      eraId: data['eraId'],
      history: data['history'],
      country: data['country'],
      civilization: data['civilization'],
      builtBy: data['builtBy'],
      constructionDate: data['constructionDate'],
      architecturalStyle: data['architecturalStyle'],
      historicalSignificance: data['historicalSignificance'],
      buildType: data['buildType'],
      historicalPeriod: data['historicalPeriod'],
      primaryMaterial: data['primaryMaterial'],
      dimensions: data['dimensions'],
      unescoStatus: data['unescoStatus'],
      purpose: data['purpose'],
      funFacts: data['funFacts'] != null ? List<String>.from(data['funFacts']) : null,
      visitorInfo: data['visitorInfo'],
      createdAt: data['createdAt']?.toString(),
      wikimediaTags: data['wikimediaTags'] != null ? List<String>.from(data['wikimediaTags']) : null,
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      imageUrls: data['imageUrls'] != null
          ? List<String>.from(data['imageUrls'])
          : const [],
      imageCaptions: data['imageCaptions'] != null
          ? Map<String, String>.from(data['imageCaptions'])
          : {},
      keyFacts: data['keyFacts'] != null ? List<String>.from(data['keyFacts']) : null,
      openingHours: data['openingHours'],
      ticketPrice: data['ticketPrice'],
      bestTimeToVisit: data['bestTimeToVisit'],
      visitDuration: data['visitDuration'],
      didYouKnow: data['didYouKnow'],
      latitude: data['coordinates'] is GeoPoint 
          ? (data['coordinates'] as GeoPoint).latitude 
          : (data['latitude'] as num?)?.toDouble(),
      longitude: data['coordinates'] is GeoPoint 
          ? (data['coordinates'] as GeoPoint).longitude 
          : (data['longitude'] as num?)?.toDouble(),
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      era: data['era'] ?? data['eraId'],
      eraEnum: PlaceEraExtension.fromString(data['eraEnum'] ?? data['era'] ?? data['eraId']),
      eraLabel: data['eraLabel'],
      city: data['city'],
      significance: data['significance'] ?? data['historicalSignificance'],
      facts: data['facts'] != null 
          ? List<String>.from(data['facts']) 
          : (data['funFacts'] != null ? List<String>.from(data['funFacts']) : null),
      timeline: data['timeline'] != null
          ? (data['timeline'] as List).map((x) => TimelineEvent.fromMap(x as Map<String, dynamic>)).toList()
          : null,
      quizzes: data['quizzes'] != null
          ? (data['quizzes'] as List).map((x) => PlaceQuiz.fromMap(x as Map<String, dynamic>)).toList()
          : null,
      associatedCharacterIds: data['associatedCharacterIds'] != null
          ? List<String>.from(data['associatedCharacterIds'])
          : null,
      colorThemeHex: data['colorThemeHex'],
      nearbyPlaceIds: data['nearbyPlaceIds'] != null
          ? List<String>.from(data['nearbyPlaceIds'])
          : null,
      aiInsightsCacheKey: data['aiInsightsCacheKey'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'location': location,
      'description': description,
      'imageUrl': imageUrl.isNotEmpty ? imageUrl : 'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?w=800',
      'eraId': eraId,
      'era': era ?? eraId, 
      'eraEnum': eraEnum?.value,
      'eraLabel': eraLabel,
      'city': city,
      'history': history,
      'country': country,
      'civilization': civilization,
      'builtBy': builtBy,
      'constructionDate': constructionDate,
      'architecturalStyle': architecturalStyle,
      'historicalSignificance': historicalSignificance,
      'buildType': buildType,
      'historicalPeriod': historicalPeriod,
      'primaryMaterial': primaryMaterial,
      'dimensions': dimensions,
      'unescoStatus': unescoStatus,
      'purpose': purpose,
      'significance': significance ?? historicalSignificance,
      'funFacts': funFacts,
      'facts': facts ?? funFacts,
      'visitorInfo': visitorInfo,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
      'wikimediaTags': wikimediaTags,
      'images': images,
      'galleryImages': images,
      'imageUrls': imageUrls,
      'imageCaptions': imageCaptions,
      'keyFacts': keyFacts,
      'openingHours': openingHours,
      'ticketPrice': ticketPrice,
      'bestTimeToVisit': bestTimeToVisit,
      'visitDuration': visitDuration,
      'didYouKnow': didYouKnow,
      'coordinates': (latitude != null && longitude != null) ? GeoPoint(latitude!, longitude!) : null,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'timeline': timeline?.map((x) => x.toMap()).toList(),
      'quizzes': quizzes?.map((x) => x.toMap()).toList(),
      'associatedCharacterIds': associatedCharacterIds,
      'colorThemeHex': colorThemeHex,
      'nearbyPlaceIds': nearbyPlaceIds,
      'aiInsightsCacheKey': aiInsightsCacheKey,
    };
  }
}
