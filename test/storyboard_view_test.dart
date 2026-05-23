import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeexplorer/models/storyboard_model.dart';
import 'package:timeexplorer/views/storyboard_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const mockStoryboard = Storyboard(
    id: 'test_sb_001',
    title: 'The Siege of Constantinople',
    era: 'Medieval Era',
    totalPanels: 3,
    panelsList: [
      StoryboardPanel(
        panelNumber: 1,
        imageUrl: '',
        description: 'The Ottoman fleet assembles in the Bosphorus.',
        audioUrl: 'https://example.com/a1.mp3',
      ),
      StoryboardPanel(
        panelNumber: 2,
        imageUrl: '',
        description: 'The great cannon Basilica fires upon the Theodosian Walls.',
        audioUrl: '',
      ),
      StoryboardPanel(
        panelNumber: 3,
        imageUrl: '',
        description: 'The city falls on 29 May 1453.',
        audioUrl: 'https://example.com/a3.mp3',
      ),
    ],
  );

  Widget buildTestWidget() {
    return const MaterialApp(
      home: StoryboardView(storyboard: mockStoryboard),
    );
  }

  /// Helper: programmatically jump to a page via the PageController
  /// by finding the PageView's controller through the widget state.
  Future<void> swipeToPage(WidgetTester tester, int page) async {
    final pageViewFinder = find.byType(PageView);
    final pageViewWidget = tester.widget<PageView>(pageViewFinder);
    pageViewWidget.controller!.jumpToPage(page);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('StoryboardView', () {
    testWidgets('renders title, era, and first panel description', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('The Siege of Constantinople'), findsOneWidget);
      expect(find.text('Medieval Era'), findsOneWidget);
      expect(find.text('The Ottoman fleet assembles in the Bosphorus.'), findsOneWidget);
    });

    testWidgets('initial progress counter shows 1 / 3', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('1 / 3'), findsOneWidget);
    });

    testWidgets('navigating pages changes text and updates counter', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Verify panel 1
      expect(find.text('The Ottoman fleet assembles in the Bosphorus.'), findsOneWidget);
      expect(find.text('1 / 3'), findsOneWidget);

      // Jump to panel 2
      await swipeToPage(tester, 1);

      expect(find.text('The great cannon Basilica fires upon the Theodosian Walls.'), findsOneWidget);
      expect(find.text('2 / 3'), findsOneWidget);

      // Jump to panel 3
      await swipeToPage(tester, 2);

      expect(find.text('The city falls on 29 May 1453.'), findsOneWidget);
      expect(find.text('3 / 3'), findsOneWidget);
    });

    testWidgets('progress bar updates value on page change', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Initial: 1/3
      var bar = tester.widget<LinearProgressIndicator>(find.byKey(const Key('progress-bar')));
      expect(bar.value, closeTo(1 / 3, 0.01));

      // Page 2
      await swipeToPage(tester, 1);

      bar = tester.widget<LinearProgressIndicator>(find.byKey(const Key('progress-bar')));
      expect(bar.value, closeTo(2 / 3, 0.01));

      // Page 3
      await swipeToPage(tester, 2);

      bar = tester.widget<LinearProgressIndicator>(find.byKey(const Key('progress-bar')));
      expect(bar.value, closeTo(3 / 3, 0.01));
    });

    testWidgets('audio button shows correct state per panel', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Panel 1 has audio
      expect(find.text('Play Narration'), findsOneWidget);

      // Panel 2 has no audio
      await swipeToPage(tester, 1);

      expect(find.text('No Audio Available'), findsOneWidget);
    });

    testWidgets('drag swipe from panel 1 to panel 2 works', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('1 / 3'), findsOneWidget);

      // Physical drag gesture
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('2 / 3'), findsOneWidget);
      expect(find.text('The great cannon Basilica fires upon the Theodosian Walls.'), findsOneWidget);
    });
  });
}
