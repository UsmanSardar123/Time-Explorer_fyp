// FILE: lib/features/places/presentation/cubit/places_list_cubit.dart
// PURPOSE: Manages fetching and providing the full list of places for the browse screen.
// SPRINT: 2

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeexplorer/features/places/domain/repositories/places_repository.dart';
import 'places_list_state.dart';

class PlacesListCubit extends Cubit<PlacesListState> {
  final PlacesRepository repository;

  PlacesListCubit({required this.repository}) : super(PlacesListInitial());

  Future<void> fetchPlaces({bool isRefresh = false}) async {
    if (!isRefresh) emit(PlacesListLoading());

    try {
      final places = await repository.fetchAllPlaces();
      
      if (places.isEmpty) {
        // We'll treat an empty list as loaded, but it could also mean an offline error if the cache was empty.
        // The repository should handle throwing or returning empty. We will emit loaded.
        emit(const PlacesListLoaded(allPlaces: []));
      } else {
        emit(PlacesListLoaded(allPlaces: places));
      }
    } catch (e) {
      emit(PlacesListError(message: 'Failed to load places. Check your connection.', isOfflineFallback: true));
    }
  }
}
