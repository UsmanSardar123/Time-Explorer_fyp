// lib/features/places/presentation/cubit/place_detail_state.dart

import 'package:equatable/equatable.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/domain/entities/timeline_event.dart';

abstract class PlaceDetailState extends Equatable {
  const PlaceDetailState();

  @override
  List<Object?> get props => [];
}

class PlaceDetailInitial extends PlaceDetailState {}

class PlaceDetailLoading extends PlaceDetailState {}

class PlaceDetailLoaded extends PlaceDetailState {
  final Place place;
  final List<TimelineEvent> timeline;
  final List<Place> nearbyPlaces;
  final String? aiInsights;

  const PlaceDetailLoaded({
    required this.place,
    required this.timeline,
    required this.nearbyPlaces,
    this.aiInsights,
  });

  @override
  List<Object?> get props => [place, timeline, nearbyPlaces, aiInsights];
}

class PlaceDetailError extends PlaceDetailState {
  final String message;
  const PlaceDetailError(this.message);
  @override
  List<Object?> get props => [message];
}
