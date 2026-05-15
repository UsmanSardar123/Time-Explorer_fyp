import 'package:equatable/equatable.dart';

enum HistoricalEra { ancient, medieval, renaissance, industrial, modern, digital }

extension HistoricalEraX on HistoricalEra {
  String get displayName => switch (this) {
        HistoricalEra.ancient => 'Ancient',
        HistoricalEra.medieval => 'Medieval',
        HistoricalEra.renaissance => 'Renaissance',
        HistoricalEra.industrial => 'Industrial Revolution',
        HistoricalEra.modern => 'Modern Era',
        HistoricalEra.digital => 'Digital Age',
      };

  String get badgeLabel => switch (this) {
        HistoricalEra.ancient => 'ANCIENT',
        HistoricalEra.medieval => 'MEDIEVAL',
        HistoricalEra.renaissance => 'RENAISSANCE',
        HistoricalEra.industrial => 'INDUSTRIAL',
        HistoricalEra.modern => 'MODERN',
        HistoricalEra.digital => 'DIGITAL',
      };

  static HistoricalEra fromString(String s) => HistoricalEra.values.firstWhere(
        (e) => e.name.toLowerCase() == s.toLowerCase(),
        orElse: () => HistoricalEra.ancient,
      );
}

class Civilization extends Equatable {
  final String id;
  final String name;
  final String timePeriod;
  final String region;
  final String description;
  final HistoricalEra era;
  final String themeColor;
  final String heroImageUrl;
  final List<String> keyThemes;
  final List<String> personalityIds;

  const Civilization({
    required this.id,
    required this.name,
    required this.timePeriod,
    required this.region,
    required this.description,
    required this.era,
    required this.themeColor,
    required this.heroImageUrl,
    this.keyThemes = const [],
    this.personalityIds = const [],
  });

  @override
  List<Object?> get props => [id, name, era, timePeriod];
}
