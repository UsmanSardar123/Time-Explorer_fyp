import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:timeexplorer/core/data/dummy_places.dart';
import 'package:timeexplorer/core/services/api_service.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/explore/domain/repositories/place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final ApiService _api;

  static const int _maxAttempts = 2;
  static const Duration _fetchTimeout = Duration(seconds: 10);
  static const Duration _retryBackoff = Duration(seconds: 2);

  List<PlaceEntity>? _cache;
  Completer<List<PlaceEntity>>? _inflightCompleter;

  PlaceRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<List<PlaceEntity>> getPlaces({String? category}) async {
    if (_cache != null && _cache!.isNotEmpty) {
      debugPrint('[PlaceRepository] Cache hit — ${_cache!.length} places.');
      return _filter(_cache!, category);
    }

    if (_inflightCompleter != null) {
      debugPrint('[PlaceRepository] Joining in-flight fetch...');
      final all = await _inflightCompleter!.future;
      return _filter(all, category);
    }

    _inflightCompleter = Completer<List<PlaceEntity>>();
    final result = await _resolveData();

    if (result.isNotEmpty) {
      _cache = result;
      debugPrint('[PlaceRepository] Cached ${result.length} places.');
    } else {
      debugPrint('[PlaceRepository] WARNING: resolved with 0 places — cache NOT written.');
    }

    _inflightCompleter!.complete(result);
    _inflightCompleter = null;
    return _filter(result, category);
  }

  /// Resolution ladder:
  ///   1. API fetch with retries
  ///   2. In-memory cache (if populated from a prior successful call)
  ///   3. Bundled local dummy data (last resort)
  Future<List<PlaceEntity>> _resolveData() async {
    final apiResult = await _fetchFromApiWithRetry();
    if (apiResult != null) return apiResult;

    debugPrint('[PlaceRepository] Using bundled local fallback.');
    return _buildLocal();
  }

  Future<List<PlaceEntity>?> _fetchFromApiWithRetry() async {
    for (int attempt = 1; attempt <= _maxAttempts; attempt++) {
      try {
        debugPrint('[PlaceRepository] API fetch attempt $attempt/$_maxAttempts...');

        final raw = await _api.get('/places').timeout(_fetchTimeout);
        final docs = (raw as List).cast<Map<String, dynamic>>();

        if (docs.isEmpty) {
          debugPrint('[PlaceRepository] Attempt $attempt: API returned empty collection — using local data.');
          return _buildLocal();
        }

        final places = _mapDocuments(docs);
        if (places.isEmpty) {
          debugPrint('[PlaceRepository] Attempt $attempt: all documents malformed — retrying.');
          if (attempt < _maxAttempts) await Future.delayed(_retryBackoff);
          continue;
        }

        debugPrint('[PlaceRepository] Attempt $attempt succeeded: ${places.length} places from API.');
        return places;
      } on TimeoutException {
        debugPrint('[PlaceRepository] Attempt $attempt timed out.');
        if (attempt < _maxAttempts) await Future.delayed(_retryBackoff);
      } catch (e) {
        debugPrint('[PlaceRepository] Attempt $attempt error: $e');
        if (attempt < _maxAttempts) await Future.delayed(_retryBackoff);
      }
    }
    debugPrint('[PlaceRepository] All $_maxAttempts API attempts failed.');
    return null;
  }

  List<PlaceEntity> _mapDocuments(List<Map<String, dynamic>> docs) {
    final result = <PlaceEntity>[];
    for (final json in docs) {
      try {
        result.add(PlaceEntity(
          id: json['id'] as String? ?? '',
          name: json['name'] as String? ?? '',
          description: json['description'] as String? ?? '',
          imageUrl: json['imageUrl'] as String? ?? '',
          category: json['category'] as String? ?? '',
          rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
          location: json['location'] as String? ?? '',
          history: json['history'] as String?,
          era: json['era'] as String?,
          quickFacts: json['quickFacts'] != null
              ? Map<String, String>.from(json['quickFacts'] as Map)
              : null,
          galleryImages: json['images'] != null
              ? List<String>.from(json['images'] as List)
              : null,
        ));
      } catch (e) {
        debugPrint('[PlaceRepository] Skipping malformed doc ${json['id']}: $e');
      }
    }
    return result;
  }

  List<PlaceEntity> _filter(List<PlaceEntity> all, String? category) {
    if (category == null || category == 'All') return all;
    return all.where((p) => p.category == category).toList();
  }

  List<PlaceEntity> _buildLocal() {
    return dummyPlaces.map((p) {
      final name = p['name'] as String;
      final id = name
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll(RegExp(r'[^a-z0-9_]'), '');
      return PlaceEntity(
        id: id,
        name: name,
        description: p['description'] as String? ?? '',
        imageUrl: p['imageUrl'] as String? ?? '',
        category: p['category'] as String? ?? '',
        rating: (p['rating'] as num?)?.toDouble() ?? 0.0,
        location: p['location'] as String? ?? '',
      );
    }).toList();
  }

  void invalidateCache() => _cache = null;
}
