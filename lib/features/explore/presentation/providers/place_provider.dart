import 'package:flutter/material.dart';
import 'package:timeexplorer/features/explore/data/repositories/place_repository_impl.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/explore/domain/usecases/place_usecases.dart';

class PlaceProvider extends ChangeNotifier {
  final PlaceRepositoryImpl _repository = PlaceRepositoryImpl();
  late final GetPlacesUseCase _getPlacesUseCase;

  // Full unfiltered list — category and search filtering happen in the getter.
  List<PlaceEntity> _allPlaces = [];
  bool _isLoading = false;
  bool _hasLoaded = false;
  String? _error;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<PlaceEntity> get places {
    Iterable<PlaceEntity> result = _allPlaces;
    if (_selectedCategory != 'All') {
      result = result.where((p) => p.category == _selectedCategory);
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((p) =>
          p.name.toLowerCase().contains(query) ||
          p.description.toLowerCase().contains(query) ||
          p.location.toLowerCase().contains(query));
    }
    return result.toList();
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
    // Do NOT call loadPlaces() here — the first page that needs data calls it.
  }

  // Category change is pure in-memory filtering; no Firestore call.
  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadPlaces() async {
    // Guard: already loaded and data is present — no need to re-fetch.
    if (_hasLoaded && _allPlaces.isNotEmpty) return;
    // Guard: a fetch is already in flight.
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _allPlaces = await _getPlacesUseCase();
      debugPrint('[PlaceProvider] Loaded ${_allPlaces.length} places.');
      // Only mark as loaded when we actually have data — empty result keeps
      // _hasLoaded false so the next navigation triggers a retry.
      _hasLoaded = _allPlaces.isNotEmpty;
      if (_allPlaces.isEmpty) {
        _error = 'No places available. Pull down to retry.';
      }
    } catch (e) {
      debugPrint('[PlaceProvider] Error loading places: $e');
      _error = e.toString();
      _hasLoaded = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _repository.invalidateCache();
    _hasLoaded = false;
    await loadPlaces();
  }
}
