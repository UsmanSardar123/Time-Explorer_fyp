import 'package:flutter/material.dart';
import 'package:timeexplorer/features/places/data/datasources/places_remote_data_source.dart';
import 'package:timeexplorer/features/places/data/repositories/places_repository_impl.dart';
import 'package:timeexplorer/features/places/domain/entities/era.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/data/eras_data.dart';

class EraProvider extends ChangeNotifier {
  final PlacesRepositoryImpl _repository = PlacesRepositoryImpl(
    remoteDataSource: PlacesRemoteDataSourceImpl(),
  );

  final List<Era> _eras = featuredEras;
  List<Era> get eras => _eras;

  bool _isLoadingPlaces = false;
  String? _error;
  List<Place> _currentEraPlaces = [];

  bool get isLoadingPlaces => _isLoadingPlaces;
  String? get error => _error;
  List<Place> get currentEraPlaces => _currentEraPlaces;

  /// Fetch places for a specific era and update the state
  Future<void> loadPlacesForEra(String eraId) async {
    _isLoadingPlaces = true;
    _error = null;
    _currentEraPlaces = [];
    notifyListeners();

    try {
      _currentEraPlaces = await _repository.getPlacesByEra(eraId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingPlaces = false;
      notifyListeners();
    }
  }
}
