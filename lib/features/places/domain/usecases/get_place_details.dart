import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/domain/repositories/places_repository.dart';

class GetPlaceDetailsUseCase {
  final PlacesRepository repository;

  GetPlaceDetailsUseCase(this.repository);

  Future<Place> call(String placeId) async {
    return await repository.getPlaceDetails(placeId);
  }
}
