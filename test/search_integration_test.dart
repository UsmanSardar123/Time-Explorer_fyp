import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/features/explore/presentation/pages/search_page.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/personalities/data/datasources/character_local_data_source.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character_category.dart';
import 'package:timeexplorer/features/event_explorer/data/datasources/event_static_data_source.dart';
import 'package:timeexplorer/features/event_explorer/domain/entities/historical_event.dart';
import 'package:timeexplorer/features/event_explorer/domain/entities/event_category.dart';

// ── Light Fakes for Data Sources ─────────────────────────────────────────────

class FakeCollectionReference extends Fake implements CollectionReference<Map<String, dynamic>> {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> _docs;
  FakeCollectionReference(this._docs);

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([GetOptions? options]) async {
    return FakeQuerySnapshot(_docs);
  }
}

class FakeQuerySnapshot extends Fake implements QuerySnapshot<Map<String, dynamic>> {
  @override
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  FakeQuerySnapshot(this.docs);
}

class FakeQueryDocumentSnapshot extends Fake implements QueryDocumentSnapshot<Map<String, dynamic>> {
  @override
  final String id;
  final Map<String, dynamic> _data;
  FakeQueryDocumentSnapshot(this.id, this._data);

  @override
  Map<String, dynamic> data() => _data;
}

class FakeFirestore extends Fake implements FirebaseFirestore {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  FakeFirestore(this.docs);

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) {
    if (path == 'places') {
      return FakeCollectionReference(docs);
    }
    throw UnimplementedError();
  }
}

class FakeCharacterLocalDataSource extends CharacterLocalDataSource {
  final List<Character> _fakeCharacters;
  FakeCharacterLocalDataSource(this._fakeCharacters);

  @override
  List<Character> getAll() => _fakeCharacters;
}

class FakeEventStaticDataSource extends EventStaticDataSource {
  final List<HistoricalEvent> _fakeEvents;
  FakeEventStaticDataSource(this._fakeEvents);

  @override
  Future<List<HistoricalEvent>> fetchAll() async => _fakeEvents;

  @override
  Future<List<HistoricalEvent>> search(String query) async {
    final q = query.toLowerCase();
    return _fakeEvents.where((e) =>
      e.title.toLowerCase().contains(q) ||
      e.location.toLowerCase().contains(q) ||
      e.description.toLowerCase().contains(q) ||
      e.period.toLowerCase().contains(q)
    ).toList();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Unique Mock Data
  final mockPlaceData = FakeQueryDocumentSnapshot('xanthos_place', {
    'name': 'Xanthos Ancient City',
    'description': 'A beautiful ancient Lycian capital city.',
    'imageUrl': 'https://example.com/xanthos.jpg',
    'category': 'Ancient Cities',
    'rating': 4.8,
    'location': 'Antalya, Turkey',
    'era': 'Ancient Era',
  });

  const mockCharacter = Character(
    id: 'hypatia',
    name: 'Hypatia of Alexandria',
    category: CharacterCategory.philosophers,
    imageUrl: 'https://example.com/hypatia.jpg',
    title: 'Neoplatonist Philosopher',
    dob: 'c. 360 AD',
    dod: '415 AD',
    description: 'A prominent mathematician, astronomer, and philosopher in Alexandria.',
    era: 'Late Antiquity',
    origin: 'Alexandria, Egypt',
    bio: 'A famous female philosopher, mathematician, and astronomer.',
    chatPrompt: 'Let us seek truth together through geometry and philosophy.',
    speechStyle: 'Calm and highly intellectual.',
    emotionalTriggers: [],
    fallbackResponses: [],
    rateLimitWarning: '',
  );

  const mockEvent = HistoricalEvent(
    id: 'versailles_treaty',
    title: 'Signing of the Treaty of Versailles',
    category: EventCategory.revolutionsAndPolitical,
    period: '28 June 1919',
    location: 'Hall of Mirrors, Versailles, France',
    description: 'The peace treaty that ended World War I between Germany and the Allied Powers.',
    timeline: [],
    imageUrl: 'https://example.com/versailles.jpg',
    importanceLevel: 5,
    keyFacts: ['Ended WWI', 'Signed in Hall of Mirrors'],
  );

  late FakeFirestore fakeFirestore;
  late FakeCharacterLocalDataSource fakeCharacterDataSource;
  late FakeEventStaticDataSource fakeEventDataSource;

  setUp(() {
    fakeFirestore = FakeFirestore([mockPlaceData]);
    fakeCharacterDataSource = FakeCharacterLocalDataSource([mockCharacter]);
    fakeEventDataSource = FakeEventStaticDataSource([mockEvent]);
  });

  Widget buildTestWidget(GoRouter router) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('Universal Search - partial string matching and detail navigation', (WidgetTester tester) async {
    String? navigatedPath;
    Object? navigatedExtra;

    final router = GoRouter(
      initialLocation: '/search',
      routes: [
        GoRoute(
          path: '/search',
          builder: (context, state) => SearchPage(
            firestore: fakeFirestore,
            characterDataSource: fakeCharacterDataSource,
            eventDataSource: fakeEventDataSource,
          ),
        ),
        GoRoute(
          path: '/place-details',
          builder: (context, state) {
            navigatedPath = '/place-details';
            navigatedExtra = state.extra;
            return const Scaffold(body: Text('Place Details Screen'));
          },
        ),
        GoRoute(
          path: '/event-detail',
          builder: (context, state) {
            navigatedPath = '/event-detail';
            navigatedExtra = state.extra;
            return const Scaffold(body: Text('Event Details Screen'));
          },
        ),
        GoRoute(
          path: '/personality-detail',
          builder: (context, state) {
            navigatedPath = '/personality-detail';
            navigatedExtra = state.extra;
            return const Scaffold(body: Text('Personality Details Screen'));
          },
        ),
      ],
    );

    await tester.pumpWidget(buildTestWidget(router));
    await tester.pump(); // Initial build
    await tester.pump(const Duration(milliseconds: 100)); // Let async init settle

    // 1. Verify Empty State initially
    expect(find.text('Where shall we travel?'), findsOneWidget);

    // 2. Search for Place via partial string ("Xanthos")
    final searchInput = find.byType(TextField);
    expect(searchInput, findsOneWidget);

    await tester.enterText(searchInput, 'Xanthos');
    await tester.pump(); // Trigger onChanged
    await tester.pump(const Duration(milliseconds: 500)); // Allow search Future to complete

    // Verify Xanthos Ancient City is shown
    expect(find.text('Xanthos Ancient City'), findsOneWidget);
    expect(find.text('Historical Places'), findsOneWidget);

    // Click on Place tile and verify navigation
    await tester.tap(find.text('Xanthos Ancient City'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(navigatedPath, '/place-details');
    expect(navigatedExtra, isA<PlaceEntity>());
    expect((navigatedExtra as PlaceEntity).id, 'xanthos_place');

    // Go back to search
    router.go('/search');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // 3. Search for Event via partial string ("Treaty")
    await tester.enterText(searchInput, 'Treaty');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Versailles Treaty is shown
    expect(find.text('Signing of the Treaty of Versailles'), findsOneWidget);
    expect(find.text('Historical Events'), findsOneWidget);

    // Click on Event tile and verify navigation
    await tester.tap(find.text('Signing of the Treaty of Versailles'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(navigatedPath, '/event-detail');
    expect(navigatedExtra, isA<HistoricalEvent>());
    expect((navigatedExtra as HistoricalEvent).id, 'versailles_treaty');

    // Go back to search
    router.go('/search');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // 4. Search for Personality via partial string ("Hypatia")
    await tester.enterText(searchInput, 'Hypatia');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Hypatia is shown
    expect(find.text('Hypatia of Alexandria'), findsOneWidget);
    expect(find.text('Historical Figures'), findsOneWidget);

    // Click on Personality tile and verify navigation
    await tester.tap(find.text('Hypatia of Alexandria'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(navigatedPath, '/personality-detail');
    expect(navigatedExtra, isA<Character>());
    expect((navigatedExtra as Character).id, 'hypatia');
  });
}
