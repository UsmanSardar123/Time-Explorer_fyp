import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeexplorer/core/services/pixabay_service.dart';
import 'package:timeexplorer/core/services/wikimedia_service.dart';

/// Centralized image resolver for Place objects.
///
/// Resolution order (fastest to slowest):
///   L1 — in-process memory map (survives hot-reload, not app restart)
///   L2 — SharedPreferences (survives app restart on same device)
///   L3 — storedUrl from Firestore (already in the place document)
///   L4 — Wikimedia pageimages thumbnail API
///   L5 — Pixabay API
///
/// On a successful L4/L5 fetch the URL is:
///   - written back to SharedPreferences (L2)
///   - written back to Firestore places/{id}.imageUrl (best-effort, fire & forget)
///
/// This means each place image is fetched from an external API at most once
/// per device. Subsequent launches resolve from L2 in milliseconds.
class PlaceImageRepository {
  PlaceImageRepository._();
  static final PlaceImageRepository instance = PlaceImageRepository._();

  static const String _prefPrefix = 'place_img_v1_';

  final Map<String, String> _memCache = {};
  final WikimediaService _wikimedia = WikimediaService();
  final PixabayService _pixabay = PixabayService();
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async =>
      _prefs ??= await SharedPreferences.getInstance();

  /// Returns the best available image URL for the place, or null if every
  /// source fails. Never throws — all errors are caught internally.
  Future<String?> resolve({
    required String placeId,
    required String placeName,
    String? storedUrl,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      // L1: memory
      if (_memCache.containsKey(placeId)) return _memCache[placeId];

      // L2: SharedPreferences
      try {
        final prefs = await _getPrefs();
        final cached = prefs.getString('$_prefPrefix$placeId');
        if (cached != null && cached.isNotEmpty) {
          _memCache[placeId] = cached;
          return cached;
        }
      } catch (_) {}

      // L3: Use the URL already stored in the place document, if it looks valid.
      if (storedUrl != null && storedUrl.isNotEmpty && storedUrl.startsWith('http')) {
        await _persist(placeId, storedUrl);
        return storedUrl;
      }
    }

    // L4: Wikimedia thumbnail API
    String? fetched;
    try {
      fetched = await _wikimedia
          .getImageUrl(placeName)
          .timeout(const Duration(seconds: 8));
    } catch (_) {}

    // L5: Pixabay fallback
    if (fetched == null || fetched.isEmpty) {
      try {
        fetched = await _pixabay
            .getImageUrl(placeName)
            .timeout(const Duration(seconds: 8));
      } catch (_) {}
    }

    if (fetched != null && fetched.isNotEmpty) {
      await _persist(placeId, fetched);
      _writeBackToFirestore(placeId, fetched); // fire & forget
    }

    return fetched;
  }

  /// Evicts a place from all local caches (e.g., after admin updates the image).
  Future<void> evict(String placeId) async {
    _memCache.remove(placeId);
    try {
      final prefs = await _getPrefs();
      await prefs.remove('$_prefPrefix$placeId');
    } catch (_) {}
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<void> _persist(String placeId, String url) async {
    _memCache[placeId] = url;
    try {
      final prefs = await _getPrefs();
      await prefs.setString('$_prefPrefix$placeId', url);
    } catch (_) {}
  }

  void _writeBackToFirestore(String placeId, String imageUrl) {
    // Best-effort, fire-and-forget. Errors are logged but never rethrown.
    FirebaseFirestore.instance
        .collection('places')
        .doc(placeId)
        .set({'imageUrl': imageUrl}, SetOptions(merge: true))
        .then((_) {
          debugPrint('[PlaceImageRepository] ✅ Saved imageUrl to Firestore for $placeId');
        })
        .catchError((e) {
          debugPrint('[PlaceImageRepository] ⚠️ Firestore write-back failed for $placeId: $e');
        });
  }
}
