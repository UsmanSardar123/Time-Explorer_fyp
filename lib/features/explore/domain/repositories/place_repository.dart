import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';

abstract class PlaceRepository {
  Future<List<PlaceEntity>> getPlaces({String? category});
}
