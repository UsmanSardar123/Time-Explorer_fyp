import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/historical_personality_model.dart';

class CivilizationEntry {
  final Map<String, dynamic> metadata;
  final List<HistoricalPersonality> personalities;

  const CivilizationEntry({
    required this.metadata,
    required this.personalities,
  });

  String get id => metadata['id'] as String;

  Map<String, dynamic> get firestoreMetadata => {
        ...metadata,
        'personalityIds': personalities.map((p) => p.id).toList(),
      };
}

/// Dynamic civilization registry — register once, seed anywhere.
/// Add new civilizations by calling [register] before [seedAll].
class CivilizationRegistry {
  static final Map<String, CivilizationEntry> _registry = {};

  /// Register a civilization for seeding. Idempotent — safe to call on restart.
  static void register(CivilizationEntry entry) {
    _registry[entry.id] = entry;
    debugPrint('[CivilizationRegistry] ✅ Registered: ${entry.id}');
  }

  /// Seed every registered civilization to Firestore.
  static Future<void> seedAll([FirebaseFirestore? db]) async {
    if (_registry.isEmpty) {
      debugPrint('[CivilizationRegistry] ⚠️ No civilizations registered.');
      return;
    }
    for (final id in _registry.keys) {
      await seedCivilization(id, db);
    }
  }

  /// Seed a single registered civilization by ID.
  static Future<void> seedCivilization(
    String id, [
    FirebaseFirestore? db,
  ]) async {
    final entry = _registry[id];
    if (entry == null) {
      debugPrint('[CivilizationRegistry] ⚠️ Not registered: $id');
      return;
    }

    final firestore = db ?? FirebaseFirestore.instance;
    try {
      final batch = firestore.batch();

      batch.set(
        firestore.collection('civilizations').doc(id),
        entry.firestoreMetadata,
      );

      final charCol = firestore.collection('characters');
      for (final p in entry.personalities) {
        batch.set(charCol.doc(p.id), p.toFirestoreMap());
      }

      await batch.commit();
      debugPrint(
        '[CivilizationRegistry] ✅ Seeded $id '
        '(${entry.personalities.length} personalities)',
      );
    } catch (e) {
      debugPrint('[CivilizationRegistry] ❌ Seed failed for $id: $e');
      rethrow;
    }
  }

  // ── Queries ────────────────────────────────────────────────────────────────

  static List<String> get registeredIds => _registry.keys.toList();

  static CivilizationEntry? get(String id) => _registry[id];

  static List<HistoricalPersonality> personalitiesFor(String id) =>
      _registry[id]?.personalities ?? const [];

  static bool isRegistered(String id) => _registry.containsKey(id);
}
