import 'package:equatable/equatable.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';

abstract class PlaceDetailsState extends Equatable {
  const PlaceDetailsState();

  @override
  List<Object?> get props => [];
}

class PlaceDetailsInitial extends PlaceDetailsState {}

class PlaceDetailsLoading extends PlaceDetailsState {}

class PlaceDetailsLoaded extends PlaceDetailsState {
  final Place place;
  final List<Place> nearbyPlaces;

  const PlaceDetailsLoaded({required this.place, required this.nearbyPlaces});

  @override
  List<Object?> get props => [place, nearbyPlaces];
}

class PlaceDetailsError extends PlaceDetailsState {
  final String message;

  const PlaceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
