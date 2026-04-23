import 'package:flutter/material.dart';
import 'package:timeexplorer/features/explore/data/repositories/place_repository_impl.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/explore/domain/usecases/place_usecases.dart';

class PlaceProvider extends ChangeNotifier {
  final PlaceRepositoryImpl _repository = PlaceRepositoryImpl();
  late final GetPlacesUseCase _getPlacesUseCase;

  List<PlaceEntity> _places = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<PlaceEntity> get places {
    if (_searchQuery.isEmpty) return _places;
    final query = _searchQuery.toLowerCase();
    return _places.where((p) => 
      p.name.toLowerCase().contains(query) || 
      p.description.toLowerCase().contains(query) ||
      p.location.toLowerCase().contains(query)
    ).toList();
  }
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  final List<String> categories = [
    'All',
    'Ancient',
    'Medieval',
    'Renaissance',
    'Industrial',
    'Modern',
  ];

  PlaceProvider() {
    _getPlacesUseCase = GetPlacesUseCase(_repository);
    loadPlaces();
  }

  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      loadPlaces();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadPlaces() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _places = await _getPlacesUseCase(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
