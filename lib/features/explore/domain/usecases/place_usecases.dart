import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/explore/domain/repositories/place_repository.dart';

class GetPlacesUseCase {
  final PlaceRepository repository;

  GetPlacesUseCase(this.repository);

  Future<List<PlaceEntity>> call({String? category}) {
    return repository.getPlaces(category: category);
  }
}
