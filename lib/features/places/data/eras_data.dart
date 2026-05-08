import 'package:timeexplorer/features/places/data/models/era_model.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';

const List<EraModel> featuredEras = [
  EraModel(
    id: 'ancient_civilizations',
    eraName: 'Ancient Civilizations',
    timePeriod: '3000 BCE – 500 BCE',
    shortDescription:
        'The rise of the first great civilizations such as Egypt, Mesopotamia, and the Indus Valley.',
    detailedDescription:
        'This era marks the emergence of organized societies, writing systems, monumental architecture, trade networks, and early governments. Civilizations like Egypt, Mesopotamia, the Indus Valley, and early Chinese dynasties developed complex cultures and technologies that laid the foundations for modern human society.',
    outerImage:
        'https://upload.wikimedia.org/wikipedia/commons/e/af/All_Gizah_Pyramids.jpg',
    innerImage:
        'https://upload.wikimedia.org/wikipedia/commons/e/e3/Kheops-Pyramid.jpg',
    keyEvents: [
      'Invention of cuneiform writing in Sumer (~3200 BCE)',
      'Construction of the Great Pyramid of Giza (~2560 BCE)',
      'Code of Hammurabi established in Babylonia (~1754 BCE)',
      'New Kingdom of Egypt — peak of pharaonic power (~1550 BCE)',
      'Iron Age begins, transforming warfare and agriculture (~1200 BCE)',
    ],
    interestingFacts: [
      'The ancient Egyptians invented one of the world\'s earliest writing systems — hieroglyphics.',
      'Mesopotamia, between the Tigris and Euphrates rivers, is widely considered the cradle of civilization.',
      'The Indus Valley Civilization built cities with advanced sewage and drainage systems over 4,000 years ago.',
      'Ancient Egyptians used a 365-day solar calendar remarkably close to the one we use today.',
    ],
  ),
  EraModel(
    id: 'classical_antiquity',
    eraName: 'Classical Antiquity',
    timePeriod: '8th Century BCE – 5th Century CE',
    shortDescription:
        'The glorious era of Greco-Roman culture, philosophy, and empire building.',
    detailedDescription:
        'Characterized by the intertwined civilizations of Ancient Greece and Rome, this period saw monumental advancements in philosophy, politics, art, and architecture. It stretches from the earliest Greek poetry of Homer through the height of the Roman Empire, eventually transitioning into the Early Middle Ages following Rome\'s decline.',
    outerImage:
        'https://upload.wikimedia.org/wikipedia/commons/d/de/Colosseo_2020.jpg',
    innerImage:
        'https://upload.wikimedia.org/wikipedia/commons/9/99/Pantheon_Rome_2009.jpg',
    keyEvents: [
      'First Olympic Games held in Olympia, Greece (776 BCE)',
      'Athenian democracy established under Cleisthenes (508 BCE)',
      'Persian Wars — Battle of Marathon and Thermopylae (490–480 BCE)',
      'Alexander the Great\'s conquests spread Greek culture across Asia (336–323 BCE)',
      'Julius Caesar\'s assassination and the fall of the Roman Republic (44 BCE)',
      'Fall of the Western Roman Empire (476 CE)',
    ],
    interestingFacts: [
      'Democracy was born in Athens around 508 BCE — citizens voted directly on laws.',
      'The Roman road network spanned over 400,000 km, connecting the vast empire.',
      'Greek philosophers Socrates, Plato, and Aristotle shaped Western thought for millennia.',
      'The Library of Alexandria, destroyed over time, was once the largest repository of knowledge in the ancient world.',
    ],
  ),
  EraModel(
    id: 'medieval_era',
    eraName: 'Medieval Era',
    timePeriod: '5th Century CE – 15th Century CE',
    shortDescription:
        'The Middle Ages: a time of castles, knights, empires, and soaring cathedrals.',
    detailedDescription:
        'Often called the Middle Ages, this era is positioned between the fall of the Western Roman Empire and the onset of the Renaissance. It saw the rise of Islamic empires, the construction of magnificent gothic cathedrals, the feudal system in Europe, and sweeping global trade routes that reshaped civilizations worldwide.',
    outerImage:
        'https://upload.wikimedia.org/wikipedia/commons/e/e0/Trakai_Island_Castle_2011.jpg',
    innerImage:
        'https://upload.wikimedia.org/wikipedia/commons/6/6e/Cit%C3%A9_de_Carcassonne_01.jpg',
    keyEvents: [
      'Fall of the Western Roman Empire marks the start of the Middle Ages (476 CE)',
      'Rise of Islam and rapid expansion across Arabia, Africa, and Europe (7th century)',
      'Viking Age — Norse explorers raid and settle across Europe (793–1066 CE)',
      'The Magna Carta signed, limiting royal power in England (1215)',
      'The Black Death devastates Europe, killing ~30% of its population (1347–1351)',
      'Gutenberg\'s printing press revolutionizes the spread of information (1440s)',
    ],
    interestingFacts: [
      'Knights followed a strict moral code called "chivalry," governing both combat and social behavior.',
      'The medieval Catholic Church was one of the most powerful political and cultural institutions in Europe.',
      'Oxford, Bologna, and Paris universities were all founded during the Medieval Era.',
      'Many medieval castles and cathedrals still stand today, a testament to the era\'s engineering mastery.',
    ],
  ),
  EraModel(
    id: 'modern_era',
    eraName: 'Modern Era',
    timePeriod: '~1500 CE – Present',
    shortDescription:
        'From the Renaissance through revolutions, industrialization, and the digital age.',
    detailedDescription:
        'The Modern Era encompasses the great transformation of human civilization from the Renaissance onwards. It includes the Scientific Revolution, the Age of Exploration, the Enlightenment, industrial and political revolutions, two World Wars, decolonization, the Cold War, and the rise of the digital information age — a period of unprecedented change, discovery, and global interconnection.',
    outerImage:
        'https://upload.wikimedia.org/wikipedia/commons/5/53/Eiffel_tower_from_trocadero.jpg',
    innerImage:
        'https://upload.wikimedia.org/wikipedia/commons/0/05/Southwest_corner_of_Central_Park%2C_looking_east%2C_NYC.jpg',
    keyEvents: [
      'Protestant Reformation reshapes Christianity across Europe (1517)',
      'Age of Exploration — Columbus reaches the Americas, Magellan circles the globe (1492–1522)',
      'Scientific Revolution: Galileo, Copernicus, Newton transform our understanding of the universe (17th century)',
      'American and French Revolutions establish new democratic ideals (1776 & 1789)',
      'Industrial Revolution transforms economies from agrarian to industrial (18th–19th century)',
      'World Wars I & II reshape global geopolitics and lead to decolonization (1914–1945)',
      'Moon landing marks the pinnacle of the Space Age (1969)',
      'Rise of the Internet and Digital Revolution connect billions globally (1990s–present)',
    ],
    interestingFacts: [
      'The printing press (~1440) made mass literacy possible for the first time in history.',
      'The Industrial Revolution began in Britain and within a century transformed every corner of the world.',
      'The 20th century alone saw more technological advancement than all previous centuries combined.',
      'The Internet now connects over 5 billion people, fundamentally changing how humanity communicates and learns.',
    ],
  ),
];

final List<PlaceModel> eraPlaces = [
  const PlaceModel(
    id: 'eiffel_tower',
    name: 'Eiffel Tower',
    category: 'Landmark',
    location: 'Paris, France',
    description: 'The iconic iron lattice tower on the Champ de Mars in Paris, named after the engineer Gustave Eiffel.',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/85/Tour_Eiffel_Wikimedia_Commons_%28cropped%29.jpg',
    rating: 4.8,
    era: 'Modern Era',
  ),
  const PlaceModel(
    id: 'burj_khalifa',
    name: 'Burj Khalifa',
    category: 'Architecture',
    location: 'Dubai, UAE',
    description: 'The tallest structure and building in the world since its topping out in 2009.',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/93/Burj_Khalifa.jpg',
    rating: 4.9,
    era: 'Modern Era',
  ),
  const PlaceModel(
    id: 'statue_of_liberty',
    name: 'Statue of Liberty',
    category: 'Monument',
    location: 'New York, USA',
    description: 'A colossal neoclassical sculpture on Liberty Island in New York Harbor.',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a1/Statue_of_Liberty_7.jpg',
    rating: 4.7,
    era: 'Modern Era',
  ),
  const PlaceModel(
    id: 'sydney_opera_house',
    name: 'Sydney Opera House',
    category: 'Performing Arts',
    location: 'Sydney, Australia',
    description: 'A multi-venue performing arts centre in Sydney, Australia, and one of the 20th century\'s most famous buildings.',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/40/Sydney_Opera_House_Sails.jpg',
    rating: 4.8,
    era: 'Modern Era',
  ),
  const PlaceModel(
    id: 'golden_gate_bridge',
    name: 'Golden Gate Bridge',
    category: 'Infrastructure',
    location: 'San Francisco, USA',
    description: 'A suspension bridge spanning the Golden Gate, the one-mile-wide strait connecting San Francisco Bay and the Pacific Ocean.',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0c/GoldenGateBridge-001.jpg',
    rating: 4.9,
    era: 'Modern Era',
  ),
];
