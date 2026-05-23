import 'package:flutter_test/flutter_test.dart';
import 'package:timeexplorer/models/storyboard_model.dart';

void main() {
  group('StoryboardPanel', () {
    const panelMap = {
      'panelNumber': 1,
      'imageUrl': 'https://example.com/panel1.jpg',
      'description': 'The gates of ancient Babylon at dawn.',
      'audioUrl': 'https://example.com/narration1.mp3',
    };

    test('fromMap creates correct instance', () {
      final panel = StoryboardPanel.fromMap(panelMap);
      expect(panel.panelNumber, 1);
      expect(panel.imageUrl, 'https://example.com/panel1.jpg');
      expect(panel.description, 'The gates of ancient Babylon at dawn.');
      expect(panel.audioUrl, 'https://example.com/narration1.mp3');
    });

    test('toMap produces correct map', () {
      const panel = StoryboardPanel(
        panelNumber: 1,
        imageUrl: 'https://example.com/panel1.jpg',
        description: 'The gates of ancient Babylon at dawn.',
        audioUrl: 'https://example.com/narration1.mp3',
      );
      expect(panel.toMap(), panelMap);
    });

    test('roundtrip serialization preserves data integrity', () {
      final original = StoryboardPanel.fromMap(panelMap);
      final roundtripped = StoryboardPanel.fromMap(original.toMap());
      expect(roundtripped, original);
    });

    test('fromMap handles missing optional strings gracefully', () {
      final panel = StoryboardPanel.fromMap({'panelNumber': 2});
      expect(panel.panelNumber, 2);
      expect(panel.imageUrl, '');
      expect(panel.description, '');
      expect(panel.audioUrl, '');
    });
  });

  group('Storyboard', () {
    final storyboardMap = {
      'title': 'The Fall of Babylon',
      'era': 'Ancient Mesopotamia',
      'totalPanels': 3,
      'panelsList': [
        {
          'panelNumber': 3,
          'imageUrl': 'https://example.com/p3.jpg',
          'description': 'Panel three — the aftermath.',
          'audioUrl': 'https://example.com/a3.mp3',
        },
        {
          'panelNumber': 1,
          'imageUrl': 'https://example.com/p1.jpg',
          'description': 'Panel one — the siege begins.',
          'audioUrl': 'https://example.com/a1.mp3',
        },
        {
          'panelNumber': 2,
          'imageUrl': 'https://example.com/p2.jpg',
          'description': 'Panel two — the walls crumble.',
          'audioUrl': 'https://example.com/a2.mp3',
        },
      ],
    };

    test('fromMap creates correct instance and sorts panels by panelNumber', () {
      final sb = Storyboard.fromMap('babylon_001', storyboardMap);
      expect(sb.id, 'babylon_001');
      expect(sb.title, 'The Fall of Babylon');
      expect(sb.era, 'Ancient Mesopotamia');
      expect(sb.totalPanels, 3);
      expect(sb.panelsList.length, 3);
      // Verify sorted order
      expect(sb.panelsList[0].panelNumber, 1);
      expect(sb.panelsList[1].panelNumber, 2);
      expect(sb.panelsList[2].panelNumber, 3);
    });

    test('toMap produces correct map', () {
      final sb = Storyboard.fromMap('babylon_001', storyboardMap);
      final map = sb.toMap();
      expect(map['title'], 'The Fall of Babylon');
      expect(map['era'], 'Ancient Mesopotamia');
      expect(map['totalPanels'], 3);
      expect((map['panelsList'] as List).length, 3);
    });

    test('roundtrip serialization preserves all field data', () {
      final original = Storyboard.fromMap('babylon_001', storyboardMap);
      final map = original.toMap();
      final roundtripped = Storyboard.fromMap('babylon_001', map);

      expect(roundtripped.id, original.id);
      expect(roundtripped.title, original.title);
      expect(roundtripped.era, original.era);
      expect(roundtripped.totalPanels, original.totalPanels);
      expect(roundtripped.panelsList.length, original.panelsList.length);

      for (var i = 0; i < original.panelsList.length; i++) {
        expect(roundtripped.panelsList[i], original.panelsList[i]);
      }
    });

    test('fromMap with empty panelsList defaults totalPanels to 0', () {
      final sb = Storyboard.fromMap('empty_001', {
        'title': 'Empty Story',
        'era': 'Unknown',
      });
      expect(sb.totalPanels, 0);
      expect(sb.panelsList, isEmpty);
    });
  });
}
