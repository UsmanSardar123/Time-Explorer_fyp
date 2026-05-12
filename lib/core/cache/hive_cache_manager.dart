import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Thin TTL-aware Hive cache. Values are stored as JSON strings.
/// Expiry is embedded in the envelope so no separate index is needed.
class HiveCacheManager {
  static const _boxName = 'app_cache';

  static Box<String>? _box;

  static Future<void> init() async {
    if (_box != null && _box!.isOpen) return;
    _box = await Hive.openBox<String>(_boxName);
    debugPrint('[HiveCacheManager] Opened box "$_boxName"');
  }

  /// Write [value] under [key] with a [ttl]. Existing entry is replaced.
  static Future<void> put(String key, dynamic value, Duration ttl) async {
    await _ensureOpen();
    final envelope = {
      'expiresAt': DateTime.now().add(ttl).millisecondsSinceEpoch,
      'data': value,
    };
    await _box!.put(key, jsonEncode(envelope));
  }

  /// Returns the cached value or null if missing / expired.
  static T? get<T>(String key) {
    if (_box == null || !_box!.isOpen) return null;
    final raw = _box!.get(key);
    if (raw == null) return null;
    try {
      final envelope = jsonDecode(raw) as Map<String, dynamic>;
      final expiresAt = envelope['expiresAt'] as int;
      if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
        _box!.delete(key);
        return null;
      }
      return envelope['data'] as T?;
    } catch (e) {
      debugPrint('[HiveCacheManager] Corrupt entry "$key": $e');
      _box!.delete(key);
      return null;
    }
  }

  static Future<void> invalidate(String key) async {
    await _ensureOpen();
    await _box!.delete(key);
  }

  static Future<void> invalidateAll() async {
    await _ensureOpen();
    await _box!.clear();
  }

  static Future<void> _ensureOpen() async {
    if (_box == null || !_box!.isOpen) await init();
  }
}

/// Cache TTL constants used across repositories.
class CacheTtl {
  static const places = Duration(hours: 24);
  static const placeDetails = Duration(hours: 24);
  static const characters = Duration(hours: 24);
  static const aiInsights = Duration(days: 7);
  static const quizQuestions = Duration(days: 30);
  static const chatSummary = Duration(hours: 6);
}

/// Canonical cache keys.
class CacheKeys {
  static const placesList = 'places_list_v1';
  static String placeDetail(String id) => 'place_detail_v1_$id';
  static const charactersList = 'characters_list_v1';
  static String characterDetail(String id) => 'character_v1_$id';
}
