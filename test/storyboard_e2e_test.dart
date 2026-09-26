import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeexplorer/services/storyboard_service.dart';
import 'package:timeexplorer/views/storyboard_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockStoryboardData = {
    'title': 'The Golden Age of Baghdad',
    'era': 'Islamic Golden Age',
    'totalPanels': 2,
    'panelsList': [
      {
        'panelNumber': 1,
        'imageUrl': '',
        'description': 'Scholars gather at the House of Wisdom.',
        'audioUrl': '',
      },
      {
        'panelNumber': 2,
        'imageUrl': '',
        'description': 'Al-Khwarizmi writes the foundations of algebra.',
        'audioUrl': 'https://example.com/algebra.mp3',
      },
    ],
  };

  group('Sprint 3 — E2E Firestore → StoryboardStreamView', () {
    testWidgets('streams storyboard data from simulated Firestore and renders UI',
        (tester) async {
      final fakeFirestore = FakeFirebaseFirestore();
      final service = StoryboardService(firestore: fakeFirestore);

      // Seed document data
      await fakeFirestore
          .collection('storyboards')
          .doc('baghdad_001')
          .set(mockStoryboardData);

      await tester.pumpWidget(MaterialApp(
        home: StoryboardStreamView(
          storyboardId: 'baghdad_001',
          service: service,
        ),
      ));
      await tester.pumpAndSettle();

      // Verify storyboard title and era
      expect(find.text('The Golden Age of Baghdad'), findsOneWidget);
      expect(find.text('Islamic Golden Age'), findsOneWidget);
      debugPrint('[E2E] ✓ Title and era rendered from Firestore stream');

      // Verify first panel content
      expect(find.text('Scholars gather at the House of Wisdom.'), findsOneWidget);
      debugPrint('[E2E] ✓ Panel 1 description rendered');

      // Verify progress counter
      expect(find.text('1 / 2'), findsOneWidget);
      debugPrint('[E2E] ✓ Progress counter shows 1 / 2');

      // Navigate to panel 2 via PageView controller
      final pageView = tester.widget<PageView>(find.byType(PageView));
      pageView.controller!.jumpToPage(1);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Al-Khwarizmi writes the foundations of algebra.'), findsOneWidget);
      expect(find.text('2 / 2'), findsOneWidget);
      expect(find.text('Play Narration'), findsOneWidget);
      debugPrint('[E2E] ✓ Panel 2 description, counter, and audio button rendered');

      // Verify progress bar at 100%
      final bar = tester.widget<LinearProgressIndicator>(
          find.byKey(const Key('progress-bar')));
      expect(bar.value, closeTo(1.0, 0.01));
      debugPrint('[E2E] ✓ Progress bar at 100% on final panel');

      debugPrint('[E2E] ══════════════════════════════════════');
      debugPrint('[E2E] All Sprint 3 E2E assertions PASSED ✓');
      debugPrint('[E2E] Data flow: FakeFirebaseFirestore → StoryboardService → StreamBuilder → StoryboardView → UI');
    });

    testWidgets('shows not-found fallback when document does not exist', (tester) async {
      final fakeFirestore = FakeFirebaseFirestore();
      final service = StoryboardService(firestore: fakeFirestore);

      await tester.pumpWidget(MaterialApp(
        home: StoryboardStreamView(
          storyboardId: 'missing_001',
          service: service,
        ),
      ));
      await tester.pumpAndSettle();

      // Falls back to default mock data when not found in Firestore
      expect(find.text('The Golden Age of Discovery'), findsOneWidget);
      debugPrint('[E2E] ✓ Not-found state rendered correctly');
    });
  });
}
