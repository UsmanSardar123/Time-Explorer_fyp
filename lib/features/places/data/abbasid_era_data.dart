import 'package:timeexplorer/features/places/data/models/era_model.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';

const EraModel abbasidEra = EraModel(
  id: 'muslim_golden_age',
  eraName: 'Muslim Golden Age',
  timePeriod: '750 CE – 1258 CE',
  shortDescription:
      'The Abbasid Caliphate era of unparalleled scientific, artistic, and architectural achievement.',
  detailedDescription:
      'The Abbasid Caliphate presided over the Islamic Golden Age, a period of extraordinary advances '
      'in mathematics, astronomy, medicine, and philosophy. Baghdad became the world\'s intellectual '
      'capital, home to the legendary House of Wisdom (Bayt al-Hikma) where scholars translated and '
      'expanded upon Greek, Persian, and Indian knowledge. This era produced algebra, advanced optics, '
      'surgical techniques, and astronomical charts that shaped the Renaissance and modern science.',
  outerImage: 'assets/images/abbasid/baghdad_hero.jpg',
  innerImage: 'assets/images/abbasid/house_of_wisdom.jpg',
  keyEvents: [
    'Foundation of Baghdad as the Abbasid capital (762 CE)',
    'The Translation Movement begins, preserving Greek and Persian knowledge (8th century)',
    'House of Wisdom (Bayt al-Hikma) reaches its peak under Caliph al-Ma\'mun (c. 830 CE)',
    'Al-Khwarizmi writes Kitab al-Mukhtasar, founding algebra (c. 820 CE)',
    'Siege of Baghdad by the Mongols ends the Abbasid Caliphate (1258 CE)',
  ],
  interestingFacts: [
    'The word "algebra" derives from al-Khwarizmi\'s treatise "Al-Kitab al-mukhtasar fi hisab al-jabr wal-muqabala."',
    'At its peak, Baghdad\'s House of Wisdom housed scholars translating texts from Greek, Persian, and Sanskrit.',
    'Fatima al-Fihri founded the University of al-Qarawiyyin in 859 CE — the world\'s oldest continuously operating university.',
    'Abbasid astronomers produced star catalogues so precise they were used by European navigators centuries later.',
  ],
);

final List<PlaceModel> abbasidPlaces = [
  const PlaceModel(
    id: 'baghdad_round_city',
    name: 'Baghdad — The Round City',
    category: 'Capital City',
    location: 'Baghdad, Iraq',
    description:
        'Founded in 762 CE by Caliph al-Mansur, Baghdad was constructed in a perfect circle and '
        'became the intellectual and commercial capital of the medieval world.',
    imageUrl: 'assets/images/abbasid/baghdad_round_city.jpg',
    rating: 4.9,
    era: 'Muslim Golden Age',
    eraId: 'muslim_golden_age',
    civilization: 'Abbasid Caliphate',
    builtBy: 'Caliph al-Mansur',
    constructionDate: '762 CE',
    history:
        'Known as Madinat al-Salam (City of Peace), Baghdad was the largest city in the world by '
        '900 CE with an estimated population of over one million inhabitants.',
  ),
  const PlaceModel(
    id: 'house_of_wisdom',
    name: 'House of Wisdom (Bayt al-Hikma)',
    category: 'Library & Academy',
    location: 'Baghdad, Iraq',
    description:
        'The greatest intellectual institution of the medieval world, where scholars translated '
        'Greek, Persian, and Indian texts and made groundbreaking advances in every field of knowledge.',
    imageUrl: 'assets/images/abbasid/house_of_wisdom.jpg',
    rating: 5.0,
    era: 'Muslim Golden Age',
    eraId: 'muslim_golden_age',
    civilization: 'Abbasid Caliphate',
    builtBy: 'Caliph Harun al-Rashid (expanded by al-Ma\'mun)',
    constructionDate: 'c. 830 CE',
    history:
        'The House of Wisdom attracted scholars from across the world and produced Al-Khwarizmi\'s '
        'algebra, Al-Kindi\'s philosophy, and Ibn al-Haytham\'s foundational work in optics.',
  ),
  const PlaceModel(
    id: 'samarra_great_mosque',
    name: 'Great Mosque of Samarra',
    category: 'Religious Monument',
    location: 'Samarra, Iraq',
    description:
        'Built by Caliph al-Mutawakkil in 851 CE, it was the world\'s largest mosque for centuries, '
        'famous for its iconic helical minaret — the Malwiya Tower.',
    imageUrl: 'assets/images/abbasid/samarra_mosque.jpg',
    rating: 4.7,
    era: 'Muslim Golden Age',
    eraId: 'muslim_golden_age',
    civilization: 'Abbasid Caliphate',
    builtBy: 'Caliph al-Mutawakkil',
    constructionDate: '851 CE',
    history:
        'The spiral Malwiya minaret stands 52 metres tall and is a UNESCO World Heritage Site, '
        'remaining one of the most recognised icons of Islamic architecture.',
  ),
  const PlaceModel(
    id: 'cairo_al_azhar',
    name: 'Al-Azhar Mosque & University, Cairo',
    category: 'Mosque & University',
    location: 'Cairo, Egypt',
    description:
        'Founded in 970 CE, Al-Azhar became the world\'s leading centre of Islamic scholarship '
        'and one of the oldest continuously operating universities on Earth.',
    imageUrl: 'assets/images/abbasid/al_azhar_cairo.jpg',
    rating: 4.8,
    era: 'Muslim Golden Age',
    eraId: 'muslim_golden_age',
    civilization: 'Islamic Golden Age',
    constructionDate: '970–972 CE',
    history:
        'Al-Azhar University has been in continuous operation since the 10th century, making it '
        'one of the oldest academic institutions in the world still in use today.',
  ),
];
