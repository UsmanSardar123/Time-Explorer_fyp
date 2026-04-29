// lib/features/places/presentation/cubit/place_detail_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeexplorer/features/places/domain/repositories/places_repository.dart';
import 'place_detail_state.dart';

class PlaceDetailCubit extends Cubit<PlaceDetailState> {
  final PlacesRepository repository;

  PlaceDetailCubit({required this.repository}) : super(PlaceDetailInitial());

  /// Fetch all necessary data for the detail screen.
  /// [placeId] is the document id of the place.
  Future<void> loadPlaceDetail(String placeId) async {
    emit(PlaceDetailLoading());
    try {
      // Fetch place entity (may be null if not found)
      final place = await repository.fetchPlaceById(placeId);
      if (place == null) {
        emit(const PlaceDetailError('Place not found'));
        return;
      }

      // Timeline events – may be empty list.
      final timeline = await repository.fetchTimeline(placeId);

      // Nearby places – use the ids stored on the place entity.
      final nearbyIds = place.nearbyPlaceIds ?? [];
      final nearbyPlaces = await repository.fetchNearbyPlacesByIds(nearbyIds);

      // AI insights – placeholder; in a real implementation this would trigger a separate service.
      final aiInsights = null; // TODO: integrate AI insights service later.

      emit(PlaceDetailLoaded(
        place: place,
        timeline: timeline,
        nearbyPlaces: nearbyPlaces,
        aiInsights: aiInsights,
      ));
    } catch (e) {
      emit(PlaceDetailError(e.toString()));
    }
  }
}
