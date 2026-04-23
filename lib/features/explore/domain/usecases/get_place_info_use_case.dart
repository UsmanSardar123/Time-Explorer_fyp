import '../entities/place_info_entity.dart';
import '../repositories/place_info_repository.dart';

class GetPlaceInfoUseCase {
  final PlaceInfoRepository _repository;

  const GetPlaceInfoUseCase(this._repository);

  Future<PlaceInfoEntity> call(String placeName) =>
      _repository.getPlaceInfo(placeName);
}
