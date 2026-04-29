// FILE: lib/models/place_era.dart
// PURPOSE: Enum for historical eras used across the Places module.
// SPRINT: 1 — TASK 1.1

enum PlaceEra {
  ancient,
  medieval,
  renaissance,
  earlyModern,
  modern,
}

extension PlaceEraExtension on PlaceEra {
  String get value {
    switch (this) {
      case PlaceEra.ancient:
        return 'ancient';
      case PlaceEra.medieval:
        return 'medieval';
      case PlaceEra.renaissance:
        return 'renaissance';
      case PlaceEra.earlyModern:
        return 'earlyModern';
      case PlaceEra.modern:
        return 'modern';
    }
  }

  static PlaceEra? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'ancient':
        return PlaceEra.ancient;
      case 'medieval':
        return PlaceEra.medieval;
      case 'renaissance':
        return PlaceEra.renaissance;
      case 'earlymodern':
      case 'early_modern':
        return PlaceEra.earlyModern;
      case 'modern':
        return PlaceEra.modern;
      default:
        return null;
    }
  }
}
