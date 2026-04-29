// FILE: lib/scripts/seed_places.dart
// PURPOSE: Robust Firestore seeding script for places with full metadata.
// SPRINT: 1 — TASK 1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import '../models/place_era.dart';

// Run this via: flutter run -t lib/scripts/seed_places.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await seedPlaces(FirebaseFirestore.instance);
}

Future<void> seedPlaces(FirebaseFirestore firestore) async {
  print('Starting place seed...');

  final places = [
    {
      'id': 'colosseum',
      'name': 'The Colosseum',
      'description': 'The Colosseum is an oval amphitheatre in the centre of the city of Rome, Italy. It is the largest ancient amphitheatre ever built.',
      'category': 'Architecture',
      'location': 'Rome, Italy',
      'imageUrl': 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800',
      'imageUrls': [
        'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800',
        'https://images.unsplash.com/photo-1525874684015-58379d421a52?w=800',
        'https://images.unsplash.com/photo-1604580864964-0462f5d5b1a8?w=800'
      ],
      'latitude': 41.8902,
      'longitude': 12.4922,
      'eraEnum': PlaceEra.ancient.value,
      'eraLabel': 'Ancient Rome (753 BC – 476 AD)',
      'country': 'Italy',
      'city': 'Rome',
      'facts': [
        'It could hold an estimated 50,000 to 80,000 spectators.',
        'Construction began under the emperor Vespasian in AD 72.',
        'It was used for gladiatorial contests and public spectacles.',
        'A complex system of vaults and tunnels was built beneath it.',
        'Earthquakes and stone-robbers have left it in a ruined state.',
      ],
      'associatedCharacterIds': ['julius_caesar', 'marcus_aurelius'],
      'nearbyPlaceIds': ['pompeii'],
      'aiInsightsCacheKey': 'insights_colosseum',
      'colorThemeHex': '#B7410E',
      'rating': 4.9,
      'timeline': [
        {
          'eraName': 'Construction',
          'year': 'AD 72 - 80',
          'description': 'Built under Emperor Vespasian and completed under his successor Titus.',
          'imageUrl': 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=200',
          'orderIndex': 1,
        },
        {
          'eraName': 'Active Use',
          'year': 'AD 80 - 435',
          'description': 'Used for gladiatorial contests and animal hunts.',
          'imageUrl': 'https://images.unsplash.com/photo-1525874684015-58379d421a52?w=200',
          'orderIndex': 2,
        }
      ]
    },
    {
      'id': 'mohenjo_daro',
      'name': 'Mohenjo-daro',
      'description': 'An archaeological site in the province of Sindh, Pakistan. Built around 2500 BCE, it was one of the largest settlements of the ancient Indus Valley Civilization.',
      'category': 'Archaeology',
      'location': 'Sindh, Pakistan',
      'imageUrl': 'https://images.unsplash.com/photo-1618413159955-4673fb3510e8?w=800',
      'imageUrls': [
        'https://images.unsplash.com/photo-1618413159955-4673fb3510e8?w=800',
        'https://images.unsplash.com/photo-1582236814238-765f0a39f600?w=800',
        'https://images.unsplash.com/photo-1583090680650-60b73c4f74d0?w=800'
      ],
      'latitude': 27.3292,
      'longitude': 68.1389,
      'eraEnum': PlaceEra.ancient.value,
      'eraLabel': 'Bronze Age (2500 BCE - 1900 BCE)',
      'country': 'Pakistan',
      'city': 'Larkana',
      'facts': [
        'Name translates to "Mound of the Dead Men".',
        'Featured a highly advanced drainage and water management system.',
        'The Great Bath is believed to be the earliest public water tank in the ancient world.',
        'Abandoned in the 19th century BCE as the Indus Valley Civilization declined.',
        'Designated as a UNESCO World Heritage site in 1980.',
      ],
      'associatedCharacterIds': [],
      'nearbyPlaceIds': [],
      'aiInsightsCacheKey': 'insights_mohenjo_daro',
      'colorThemeHex': '#D4A373',
      'rating': 4.8,
      'timeline': [
        {
          'eraName': 'Peak Civilization',
          'year': '2500 BCE - 1900 BCE',
          'description': 'Thrived as an advanced urban center with complex civil engineering.',
          'imageUrl': 'https://images.unsplash.com/photo-1618413159955-4673fb3510e8?w=200',
          'orderIndex': 1,
        },
        {
          'eraName': 'Decline',
          'year': '1900 BCE - 1300 BCE',
          'description': 'Gradual abandonment possibly due to changing river courses and climate.',
          'imageUrl': 'https://images.unsplash.com/photo-1582236814238-765f0a39f600?w=200',
          'orderIndex': 2,
        }
      ]
    },
    {
      'id': 'great_wall',
      'name': 'The Great Wall of China',
      'description': 'A series of fortifications that were built across the historical northern borders of ancient Chinese states and Imperial China as protection against various nomadic groups from the Eurasian Steppe.',
      'category': 'Architecture',
      'location': 'China',
      'imageUrl': 'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=800',
      'imageUrls': [
        'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=800',
        'https://images.unsplash.com/photo-1542382414-b4904c6a61b4?w=800',
        'https://images.unsplash.com/photo-1563215264-9f75ec5de195?w=800'
      ],
      'latitude': 40.4319,
      'longitude': 116.5704,
      'eraEnum': PlaceEra.medieval.value,
      'eraLabel': 'Ming Dynasty (1368 - 1644)',
      'country': 'China',
      'city': 'Beijing',
      'facts': [
        'Total length is over 21,196 km (13,171 miles).',
        'Built over multiple dynasties, mainly the Ming dynasty.',
        'Constructed using stone, brick, tamped earth, wood, and other materials.',
        'Also served as border controls and for imposing duties on Silk Road trade.',
        'Not a single continuous wall, but a collection of walls and trenches.',
      ],
      'associatedCharacterIds': ['sun_tzu'],
      'nearbyPlaceIds': [],
      'aiInsightsCacheKey': 'insights_great_wall',
      'colorThemeHex': '#556B2F',
      'rating': 4.9,
      'timeline': [
        {
          'eraName': 'Early Walls',
          'year': '7th century BC',
          'description': 'Various Chinese states built independent walls to defend against nomads.',
          'imageUrl': 'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=200',
          'orderIndex': 1,
        },
        {
          'eraName': 'Ming Dynasty Rebuilding',
          'year': '1368 - 1644',
          'description': 'The most extensive and best-preserved sections were built during the Ming dynasty.',
          'imageUrl': 'https://images.unsplash.com/photo-1542382414-b4904c6a61b4?w=200',
          'orderIndex': 2,
        }
      ]
    }
  ];

  final batch = firestore.batch();

  for (var place in places) {
    final docRef = firestore.collection('places').doc(place['id'] as String);
    
    // Extract and remove timeline to save as subcollection
    final timelineData = place['timeline'] as List<dynamic>?;
    place.remove('timeline');
    
    batch.set(docRef, place);

    if (timelineData != null) {
      for (var entry in timelineData) {
        final Map<String, dynamic> entryMap = entry as Map<String, dynamic>;
        final timelineRef = docRef.collection('timeline').doc();
        batch.set(timelineRef, entryMap);
      }
    }
  }

  await batch.commit();
  print('✅ Seed completed successfully. Seeded ${places.length} places.');
}
