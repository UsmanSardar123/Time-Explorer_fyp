import 'package:timeexplorer/features/places/data/datasources/places_remote_data_source.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/domain/repositories/places_repository.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesRemoteDataSource remoteDataSource;

  PlacesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Place> getPlaceDetails(String placeId) async {
    return await remoteDataSource.getPlaceDetails(placeId);
  }

  @override
  Future<List<Place>> getNearbyPlaces(String category, String excludeId) async {
    return await remoteDataSource.getNearbyPlaces(category, excludeId);
  }

  @override
  Future<List<Place>> getPlacesByEra(String eraId) async {
    return await remoteDataSource.getPlacesByEra(eraId);
  }

  @override
  Future<void> updatePlace(PlaceModel place) async {
    return await remoteDataSource.updatePlace(place);
  }

  @override
  Future<void> deletePlace(String placeId) async {
    return await remoteDataSource.deletePlace(placeId);
  }
}
