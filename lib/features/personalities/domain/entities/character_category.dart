import 'package:flutter/material.dart';

enum CharacterCategory {
  scientists,
  philosophers,
  emperors,
  poets,
  explorers,
  leaders,
  artists,
  writers;

  String get displayName {
    switch (this) {
      case CharacterCategory.scientists:   return 'Scientists';
      case CharacterCategory.philosophers: return 'Philosophers';
      case CharacterCategory.emperors:     return 'Emperors';
      case CharacterCategory.poets:        return 'Poets';
      case CharacterCategory.explorers:    return 'Explorers';
      case CharacterCategory.leaders:      return 'Leaders';
      case CharacterCategory.artists:      return 'Artists';
      case CharacterCategory.writers:      return 'Writers';
    }
  }

  IconData get icon {
    switch (this) {
      case CharacterCategory.scientists:   return Icons.science_rounded;
      case CharacterCategory.philosophers: return Icons.psychology_rounded;
      case CharacterCategory.emperors:     return Icons.shield_rounded;
      case CharacterCategory.poets:        return Icons.auto_stories_rounded;
      case CharacterCategory.explorers:    return Icons.explore_rounded;
      case CharacterCategory.leaders:      return Icons.military_tech_rounded;
      case CharacterCategory.artists:      return Icons.palette_rounded;
      case CharacterCategory.writers:      return Icons.menu_book_rounded;
    }
  }

  String get subtitle {
    switch (this) {
      case CharacterCategory.scientists:   return 'Minds that changed the world';
      case CharacterCategory.philosophers: return 'Thinkers who shaped thought';
      case CharacterCategory.emperors:     return 'Rulers who forged empires';
      case CharacterCategory.poets:        return 'Words that moved the world';
      case CharacterCategory.explorers:    return 'Adventurers of the unknown';
      case CharacterCategory.leaders:      return 'Rulers who shaped history';
      case CharacterCategory.artists:      return 'Creators of beauty';
      case CharacterCategory.writers:      return 'Masters of the written word';
    }
  }
}
