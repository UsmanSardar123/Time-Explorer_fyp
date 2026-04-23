import 'package:timeexplorer/features/places/data/models/era_model.dart';
import 'package:timeexplorer/features/places/data/models/place_model.dart';

const List<EraModel> featuredEras = [
  EraModel(
    id: 'ancient_civilizations',
    eraName: 'Ancient Civilizations',
    timePeriod: '3000 BCE – 500 BCE',
    shortDescription: 'The rise of the first great civilizations such as Egypt, Mesopotamia, and the Indus Valley.',
    detailedDescription: 'This era marks the emergence of organized societies, writing systems, monumental architecture, trade networks, and early governments. Civilizations like Egypt, Mesopotamia, the Indus Valley, and early Chinese dynasties developed complex cultures and technologies that laid the foundations for modern human society.',
    outerImage: 'https://upload.wikimedia.org/wikipedia/commons/e/af/All_Gizah_Pyramids.jpg',
    innerImage: 'https://upload.wikimedia.org/wikipedia/commons/e/e3/Kheops-Pyramid.jpg',
  ),
  EraModel(
    id: 'classical_antiquity',
    eraName: 'Classical Antiquity',
    timePeriod: '8th Century BCE – 5th Century CE',
    shortDescription: 'The glorious era of Greco-Roman culture, philosophy, and empire building.',
    detailedDescription: 'Characterized by the intertwined civilizations of Ancient Greece and Rome, this period saw monumental advancements in philosophy, politics, art, and architecture. It stretches from the earliest Greek poetry of Homer through the height of the Roman Empire, eventually transitioning into the Early Middle Ages following Rome\'s decline.',
    outerImage: 'https://upload.wikimedia.org/wikipedia/commons/d/de/Colosseo_2020.jpg',
    innerImage: 'https://upload.wikimedia.org/wikipedia/commons/9/99/Pantheon_Rome_2009.jpg',
  ),
  EraModel(
    id: 'medieval_era',
    eraName: 'Medieval Era',
    timePeriod: '5th Century CE – 15th Century CE',
    shortDescription: 'The Middle Ages: a time of castles, knights, empires, and soaring cathedrals.',
    detailedDescription: 'Often called the Middle Ages, this era in human history is positioned between the fall of the Western Roman Empire and the onset of the Renaissance. It saw the rise of Islamic empires, the construction of magnificent gothic cathedrals, the feudal system in Europe, and sweeping global trade routes that reshaped civilizations worldwide.',
    outerImage: 'https://upload.wikimedia.org/wikipedia/commons/e/e0/Trakai_Island_Castle_2011.jpg',
    innerImage: 'https://upload.wikimedia.org/wikipedia/commons/6/6e/Cité_de_Carcassonne_01.jpg',
  ),
];

final List<PlaceModel> eraPlaces = [];
