import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeexplorer/views/storyboard_card.dart';
import 'package:timeexplorer/views/storyboard_view.dart';
import 'package:timeexplorer/services/storyboard_service.dart';
import 'package:timeexplorer/models/storyboard_model.dart';
import 'dart:async';

class MockStoryboardService implements StoryboardService {
  @override
  Stream<Storyboard?> streamStoryboardById(String id) {
    return Stream.value(null);
  }

  @override
  Future<Storyboard?> getStoryboardById(String id) async {
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('StoryboardCard has non-zero constraints and does not collapse', (tester) async {
    final mockService = MockStoryboardService();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              const Text('Top content'),
              StoryboardCard(storyboardId: 'test_id', service: mockService),
              const Text('Bottom content'),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final cardFinder = find.byType(StoryboardCard);
    expect(cardFinder, findsOneWidget);

    final RenderBox renderBox = tester.renderObject(cardFinder);
    
    // Check that it does not collapse (height should be strictly > 0, 
    // exactly 400 according to our implementation)
    expect(renderBox.size.height, greaterThan(0));
    expect(renderBox.size.height, equals(400.0));
    expect(renderBox.size.width, greaterThan(0));

    // Verify it renders the inner StreamView which indicates it's mounted
    expect(find.byType(StoryboardStreamView), findsOneWidget);
  });
}
