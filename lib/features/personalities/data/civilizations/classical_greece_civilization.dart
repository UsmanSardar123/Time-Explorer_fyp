import '../models/historical_personality_model.dart';
import 'classical_greece_personalities.dart';

abstract class ClassicalGreeceCivilization {
  static const String id = 'classical_greece';

  static const Map<String, dynamic> metadata = {
    'id': id,
    'name': 'Classical Greece',
    'timePeriod': '600 BCE – 146 BCE',
    'region': 'Aegean, Eastern Mediterranean',
    'era': 'ancient',
    'themeColor': '#5B7FA6',
    'heroImageUrl': 'assets/images/civilizations/classical_greece_hero.jpg',
    'description':
        'Classical Greece forged the philosophical, scientific, and democratic '
        'foundations of Western civilisation — from Socratic inquiry and Euclidean '
        'geometry to Alexandrian conquest and tragic theatre.',
    'keyThemes': [
      'democratic governance',
      'Socratic philosophy',
      'mathematical proof',
      'theatrical drama',
      'military strategy and empire',
    ],
  };

  static List<HistoricalPersonality> get personalities =>
      ClassicalGreecePersonalities.all;

  static List<String> get personalityIds =>
      ClassicalGreecePersonalities.all.map((p) => p.id).toList();

  static Map<String, dynamic> get firestoreMetadata => {
        ...metadata,
        'personalityIds': personalityIds,
      };
}
