// FILE: lib/features/places/presentation/cubit/places_list_state.dart
// PURPOSE: States for the Places List Screen (Sprint 2)
// SPRINT: 2

import 'package:equatable/equatable.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';

abstract class PlacesListState extends Equatable {
  const PlacesListState();

  @override
  List<Object?> get props => [];
}

class PlacesListInitial extends PlacesListState {}

class PlacesListLoading extends PlacesListState {}

class PlacesListLoaded extends PlacesListState {
  final List<Place> allPlaces;

  const PlacesListLoaded({required this.allPlaces});

  @override
  List<Object?> get props => [allPlaces];
}

class PlacesListError extends PlacesListState {
  final String message;
  final bool isOfflineFallback;

  const PlacesListError({required this.message, this.isOfflineFallback = false});

  @override
  List<Object?> get props => [message, isOfflineFallback];
}
