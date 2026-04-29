import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeexplorer/core/services/wikipedia_service.dart';
import 'package:timeexplorer/features/places/domain/usecases/get_nearby_places.dart';
import 'package:timeexplorer/features/places/domain/usecases/get_place_details.dart';
import 'package:timeexplorer/features/places/presentation/cubit/place_details_state.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';

class PlaceDetailsCubit extends Cubit<PlaceDetailsState> {
  final GetPlaceDetailsUseCase getPlaceDetails;
  final GetNearbyPlacesUseCase getNearbyPlaces;
  final WikipediaService wikipediaService = WikipediaService();

  PlaceDetailsCubit({
    required this.getPlaceDetails,
    required this.getNearbyPlaces,
  }) : super(PlaceDetailsInitial());

  Future<void> loadPlaceDetails(String placeId) async {
    emit(PlaceDetailsLoading());
    try {
      var place = await getPlaceDetails(placeId);
      final nearbyPlaces = await getNearbyPlaces(place.category, place.id);

      // Fetch from Wikipedia if attributes are missing
      if (place.builtBy == null ||
          place.constructionDate == null ||
          place.civilization == null) {
        try {
          final wikiData = await wikipediaService.fetchMetadata(place.name);
          
          // Re-create place with updated data (since Place is immutable)
          place = Place(
            id: place.id,
            name: place.name,
            category: place.category,
            location: place.location,
            description: place.description,
            imageUrl: place.imageUrl,
            eraId: place.eraId,
            history: place.history ?? wikiData['fallback'],
            country: place.country,
            civilization: place.civilization ?? wikiData['civilization'],
            builtBy: place.builtBy ?? wikiData['builtBy'],
            constructionDate: place.constructionDate ?? wikiData['yearBuilt'],
            architecturalStyle: place.architecturalStyle ?? wikiData['archStyle'],
            historicalSignificance: place.historicalSignificance,
            funFacts: place.funFacts,
            visitorInfo: place.visitorInfo,
            createdAt: place.createdAt,
            images: place.images,
            keyFacts: place.keyFacts,
            openingHours: place.openingHours,
            ticketPrice: place.ticketPrice,
            bestTimeToVisit: place.bestTimeToVisit,
            visitDuration: place.visitDuration,
            didYouKnow: place.didYouKnow,
            latitude: place.latitude,
            longitude: place.longitude,
            rating: place.rating,
            era: place.era,
            significance: place.significance,
            facts: place.facts,
            timeline: place.timeline,
            quizzes: place.quizzes,
            associatedCharacterIds: place.associatedCharacterIds,
            colorThemeHex: place.colorThemeHex,
            nearbyPlaceIds: place.nearbyPlaceIds,
            aiInsightsCacheKey: place.aiInsightsCacheKey,
          );
        } catch (e) {
          print('[PlaceDetailsCubit] Wikipedia fetch failed: $e');
        }
      }

      emit(PlaceDetailsLoaded(place: place, nearbyPlaces: nearbyPlaces));
    } catch (e) {
      emit(PlaceDetailsError(e.toString()));
    }
  }
}

