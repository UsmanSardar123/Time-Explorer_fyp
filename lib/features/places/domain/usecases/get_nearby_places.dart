import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/domain/repositories/places_repository.dart';

class GetNearbyPlacesUseCase {
  final PlacesRepository repository;

  GetNearbyPlacesUseCase(this.repository);

  Future<List<Place>> call(String category, String excludeId) async {
    return await repository.getNearbyPlaces(category, excludeId);
  }
}
