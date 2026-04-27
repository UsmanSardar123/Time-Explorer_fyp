import 'package:flutter_test/flutter_test.dart';
import 'package:timeexplorer/features/gamification/domain/entities/user_progress.dart';

void main() {
  group('UserProgress Level Calculation (Quadratic)', () {
    test('Level 1 should be at 0 XP', () {
      expect(UserProgress.calculateLevel(0), 1);
      expect(UserProgress.calculateLevel(-10), 1);
    });

    test('Level 2 should start at 100 XP', () {
      expect(UserProgress.calculateLevel(100), 2);
      expect(UserProgress.calculateLevel(99), 1);
    });

    test('Level 3 should start at 400 XP', () {
      expect(UserProgress.calculateLevel(400), 3);
      expect(UserProgress.calculateLevel(399), 2);
    });

    test('Level 4 should start at 900 XP', () {
      expect(UserProgress.calculateLevel(900), 4);
      expect(UserProgress.calculateLevel(899), 3);
    });

    test('xpForLevel should return correct values', () {
      expect(UserProgress.xpForLevel(1), 0);
      expect(UserProgress.xpForLevel(2), 100);
      expect(UserProgress.xpForLevel(3), 400);
      expect(UserProgress.xpForLevel(4), 900);
    });

    test('progressToNextLevel should return correct ratio', () {
      // At 50 XP, halfway to Level 2 (100 XP)
      const up = UserProgress(xp: 50, level: 1);
      expect(up.progressToNextLevel, 0.5);

      // At 250 XP, halfway between Level 2 (100) and Level 3 (400)
      // range is 300 XP. 250 - 100 = 150. 150/300 = 0.5
      const up2 = UserProgress(xp: 250, level: 2);
      expect(up2.progressToNextLevel, 0.5);
    });
  });
}
