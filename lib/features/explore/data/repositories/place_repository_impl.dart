import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:timeexplorer/core/data/dummy_places.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/explore/domain/repositories/place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final FirebaseFirestore _firestore;

  // Number of server-fetch attempts before giving up and falling back.
  static const int _maxServerAttempts = 2;
  // Per-attempt hard timeout.
  static const Duration _fetchTimeout = Duration(seconds: 10);
  // Wait between consecutive retry attempts.
  static const Duration _retryBackoff = Duration(seconds: 2);

  // Only written when a complete, non-empty, server-confirmed snapshot arrives.
  List<PlaceEntity>? _cache;
  // Coalesces concurrent calls onto a single in-flight fetch.
  Completer<List<PlaceEntity>>? _inflightCompleter;

  PlaceRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<PlaceEntity>> getPlaces({String? category}) async {
    // Serve from in-memory cache when it holds valid data.
    if (_cache != null && _cache!.isNotEmpty) {
      debugPrint('[PlaceRepository] Cache hit — ${_cache!.length} places.');
      return _filter(_cache!, category);
    }

    // Any concurrent caller waits for the single in-flight fetch to resolve.
    if (_inflightCompleter != null) {
      debugPrint('[PlaceRepository] Joining in-flight fetch...');
      final all = await _inflightCompleter!.future;
      return _filter(all, category);
    }

    _inflightCompleter = Completer<List<PlaceEntity>>();

    final List<PlaceEntity> result = await _resolveData();

    // Cache only when we have a complete, non-empty dataset.
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
  ///   1. Server fetch with retries (stable, complete snapshot).
  ///   2. SDK local cache (offline fallback — data from last server sync).
  ///   3. Bundled local dummy data (last resort).
  Future<List<PlaceEntity>> _resolveData() async {
    // ── Step 1: server fetch with retry ──────────────────────────────────────
    final serverResult = await _fetchFromServerWithRetry();
    if (serverResult != null) return serverResult;

    // ── Step 2: SDK local cache ───────────────────────────────────────────────
    debugPrint('[PlaceRepository] Trying SDK local cache after server failure...');
    final cacheResult = await _fetchFromSdkCache();
    if (cacheResult != null && cacheResult.isNotEmpty) {
      debugPrint('[PlaceRepository] SDK cache: ${cacheResult.length} places.');
      return cacheResult;
    }

    // ── Step 3: bundled local data ────────────────────────────────────────────
    debugPrint('[PlaceRepository] Using bundled local fallback.');
    return _buildLocal();
  }

  /// Attempts up to [_maxServerAttempts] direct-server fetches.
  /// Returns null only when all attempts are exhausted (caller should fall back).
  Future<List<PlaceEntity>?> _fetchFromServerWithRetry() async {
    for (int attempt = 1; attempt <= _maxServerAttempts; attempt++) {
      try {
        debugPrint(
            '[PlaceRepository] Server fetch attempt $attempt/$_maxServerAttempts...');

        final snapshot = await _firestore
            .collection('places')
            // Source.server bypasses the SDK's local persistence and requests
            // a fresh response directly from Firestore backend, preventing
            // partial / cache-first responses from being treated as complete data.
            .get(const GetOptions(source: Source.server))
            .timeout(_fetchTimeout);

        // Defensive guard: Source.server should never return isFromCache=true,
        // but reject it explicitly to be safe — partial cache snapshots are
        // exactly the root cause of the "incomplete data" bug.
        if (snapshot.metadata.isFromCache) {
          debugPrint(
              '[PlaceRepository] Attempt $attempt: snapshot is cache-sourced — '
              'ignoring as unstable.');
          if (attempt < _maxServerAttempts) {
            await Future.delayed(_retryBackoff);
          }
          continue;
        }

        // An empty verified-server collection is valid and complete.
        // Use local data rather than retrying — Firestore really is empty.
        if (snapshot.docs.isEmpty) {
          debugPrint(
              '[PlaceRepository] Attempt $attempt: server collection empty — '
              'switching to local data.');
          return _buildLocal();
        }

        final places = _mapDocuments(snapshot.docs);

        // If mapping produced zero valid entities despite non-empty docs,
        // every document was malformed — retry rather than caching garbage.
        if (places.isEmpty) {
          debugPrint(
              '[PlaceRepository] Attempt $attempt: all documents were malformed '
              '— retrying.');
          if (attempt < _maxServerAttempts) {
            await Future.delayed(_retryBackoff);
          }
          continue;
        }

        debugPrint(
            '[PlaceRepository] Attempt $attempt succeeded: '
            '${places.length} valid places from server.');
        return places;
      } on TimeoutException {
        debugPrint(
            '[PlaceRepository] Attempt $attempt timed out after '
            '${_fetchTimeout.inSeconds}s.');
        if (attempt < _maxServerAttempts) {
          await Future.delayed(_retryBackoff);
        }
      } catch (e) {
        debugPrint('[PlaceRepository] Attempt $attempt error: $e');
        if (attempt < _maxServerAttempts) {
          await Future.delayed(_retryBackoff);
        }
      }
    }

    debugPrint(
        '[PlaceRepository] All $_maxServerAttempts server attempts failed.');
    return null;
  }

  /// Reads whatever the Firestore SDK has persisted locally.
  /// This succeeds instantly even offline and returns the last-known server state.
  Future<List<PlaceEntity>?> _fetchFromSdkCache() async {
    try {
      final snapshot = await _firestore
          .collection('places')
          .get(const GetOptions(source: Source.cache));

      if (snapshot.docs.isEmpty) return null;
      final places = _mapDocuments(snapshot.docs);
      return places.isEmpty ? null : places;
    } catch (e) {
      debugPrint('[PlaceRepository] SDK cache read failed: $e');
      return null;
    }
  }

  /// Maps Firestore documents to entities.
  /// Each document is wrapped in its own try-catch so a single malformed doc
  /// cannot discard valid data from the rest of the snapshot.
  List<PlaceEntity> _mapDocuments(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final result = <PlaceEntity>[];
    for (final doc in docs) {
      try {
        final json = doc.data();
        result.add(PlaceEntity(
          id: doc.id,
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
        debugPrint('[PlaceRepository] Skipping malformed doc ${doc.id}: $e');
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
