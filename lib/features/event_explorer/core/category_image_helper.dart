import '../domain/entities/event_category.dart';

String getCategoryImageAsset(EventCategory category) => switch (category) {
      EventCategory.warsAndConflicts =>
        'assets/images/events/placeholder_warsAndConflicts.png',
      EventCategory.revolutionsAndPolitical =>
        'assets/images/events/placeholder_revolutionsAndPolitical.png',
      EventCategory.scienceAndDiscoveries =>
        'assets/images/events/placeholder_scienceAndDiscoveries.png',
      EventCategory.cultureAndCivilizations =>
        'assets/images/events/placeholder_cultureAndCivilizations.png',
    };
