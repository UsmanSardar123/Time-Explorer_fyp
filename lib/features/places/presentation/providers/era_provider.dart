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
      
      // Fallback for Modern Era if no data in Firestore
      if (_currentEraPlaces.isEmpty && eraId == 'modern_era') {
        _currentEraPlaces = [
          const Place(
            id: 'eiffel_tower',
            name: 'Eiffel Tower',
            category: 'Landmark',
            location: 'Paris, France',
            description: 'The iconic iron lattice tower on the Champ de Mars in Paris, named after the engineer Gustave Eiffel.',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/85/Tour_Eiffel_Wikimedia_Commons_%28cropped%29.jpg',
            rating: 4.8,
            era: 'Modern Era',
          ),
          const Place(
            id: 'burj_khalifa',
            name: 'Burj Khalifa',
            category: 'Architecture',
            location: 'Dubai, UAE',
            description: 'The tallest structure and building in the world since its topping out in 2009.',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/93/Burj_Khalifa.jpg',
            rating: 4.9,
            era: 'Modern Era',
          ),
          const Place(
            id: 'statue_of_liberty',
            name: 'Statue of Liberty',
            category: 'Monument',
            location: 'New York, USA',
            description: 'A colossal neoclassical sculpture on Liberty Island in New York Harbor.',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a1/Statue_of_Liberty_7.jpg',
            rating: 4.7,
            era: 'Modern Era',
          ),
          const Place(
            id: 'sydney_opera_house',
            name: 'Sydney Opera House',
            category: 'Performing Arts',
            location: 'Sydney, Australia',
            description: 'A multi-venue performing arts centre in Sydney, Australia, and one of the 20th century\'s most famous buildings.',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/40/Sydney_Opera_House_Sails.jpg',
            rating: 4.8,
            era: 'Modern Era',
          ),
          const Place(
            id: 'golden_gate_bridge',
            name: 'Golden Gate Bridge',
            category: 'Infrastructure',
            location: 'San Francisco, USA',
            description: 'A suspension bridge spanning the Golden Gate, the one-mile-wide strait connecting San Francisco Bay and the Pacific Ocean.',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0c/GoldenGateBridge-001.jpg',
            rating: 4.9,
            era: 'Modern Era',
          ),
          const Place(
            id: 'tokyo_skytree',
            name: 'Tokyo Skytree',
            category: 'Tower',
            location: 'Tokyo, Japan',
            description: 'A broadcasting and observation tower in Sumida, Tokyo. It became the tallest structure in Japan in 2010.',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/91/Tokyo_Skytree_2014_HL2.jpg',
            rating: 4.6,
            era: 'Modern Era',
          ),
          const Place(
            id: 'statue_of_unity',
            name: 'Statue of Unity',
            category: 'Monument',
            location: 'Gujarat, India',
            description: 'The world\'s tallest statue, with a height of 182 metres (597 feet), depicting Indian statesman Vallabhbhai Patel.',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/07/Statue_of_Unity.jpg',
            rating: 4.7,
            era: 'Modern Era',
          ),
        ];
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingPlaces = false;
      notifyListeners();
    }
  }
}
