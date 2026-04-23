import '../entities/place_info_entity.dart';

abstract class PlaceInfoRepository {
  Future<PlaceInfoEntity> getPlaceInfo(String placeName);
}
