import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'event_category.g.dart';

@HiveType(typeId: 20)
enum EventCategory {
  @HiveField(0)
  warsAndConflicts,
  @HiveField(1)
  revolutionsAndPolitical,
  @HiveField(2)
  scienceAndDiscoveries,
  @HiveField(3)
  cultureAndCivilizations;

  String get displayName => switch (this) {
        warsAndConflicts        => 'Wars & Conflicts',
        revolutionsAndPolitical => 'Revolutions & Politics',
        scienceAndDiscoveries   => 'Science & Discoveries',
        cultureAndCivilizations => 'Culture & Civilizations',
      };

  IconData get icon => switch (this) {
        warsAndConflicts        => Icons.military_tech_outlined,
        revolutionsAndPolitical => Icons.account_balance_outlined,
        scienceAndDiscoveries   => Icons.science_outlined,
        cultureAndCivilizations => Icons.auto_stories_outlined,
      };
      
  Color get color => switch (this) {
        warsAndConflicts        => const Color(0xFFDC2626),
        revolutionsAndPolitical => const Color(0xFF1D4ED8),
        scienceAndDiscoveries   => const Color(0xFF059669),
        cultureAndCivilizations => const Color(0xFF7C3AED),
      };

  String get searchKeyword => switch (this) {
        warsAndConflicts        => 'war,battlefield,history',
        revolutionsAndPolitical => 'revolution,protest,politics',
        scienceAndDiscoveries   => 'science,laboratory,discovery,space',
        cultureAndCivilizations => 'culture,civilization,ancient,temple',
      };

  static EventCategory fromString(String value) {
    return EventCategory.values.firstWhere(
      (e) => e.name == value || e.displayName == value,
      orElse: () => EventCategory.cultureAndCivilizations,
    );
  }
}