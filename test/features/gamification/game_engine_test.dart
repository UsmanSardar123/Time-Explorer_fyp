import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeexplorer/features/gamification/data/services/game_progress_service.dart';
import 'package:timeexplorer/features/gamification/domain/entities/game_progress.dart';

void main() {
  // ── XP / Level formula ────────────────────────────────────────────────────

  group('Level calculation (Level = floor(sqrt(totalXP / 100)))', () {
    test('0 XP → Level 0', () {
      expect(GameProgressService.calculateLevel(0), equals(0));
    });

    test('99 XP → Level 0 (boundary)', () {
      expect(GameProgressService.calculateLevel(99), equals(0));
    });

    test('100 XP → Level 1', () {
      expect(GameProgressService.calculateLevel(100), equals(1));
    });

    test('399 XP → Level 1 (one below Level 2 threshold)', () {
      expect(GameProgressService.calculateLevel(399), equals(1));
    });

    test('400 XP → Level 2', () {
      expect(GameProgressService.calculateLevel(400), equals(2));
    });

    test('900 XP → Level 3', () {
      expect(GameProgressService.calculateLevel(900), equals(3));
    });
  });

  // ── Rank thresholds ───────────────────────────────────────────────────────

  group('Rank mapping', () {
    test('Level 0 → Nomad', () {
      expect(GameProgress.fromXPAndStreak(0, 0).rankLabel, equals('Nomad'));
    });

    test('Level 5 → Nomad (upper boundary)', () {
      expect(GameProgress.fromXPAndStreak(2500, 0).rankLabel, equals('Nomad'));
    });

    test('Level 6 → Chronos Explorer', () {
      // Level 6 threshold: 6² × 100 = 3600 XP
      expect(GameProgress.fromXPAndStreak(3600, 0).rankLabel, equals('Chronos Explorer'));
    });

    test('Level 16 → Master of Ages', () {
      // Level 16 threshold: 16² × 100 = 25600 XP
      expect(GameProgress.fromXPAndStreak(25600, 0).rankLabel, equals('Master of Ages'));
    });
  });

  // ── XP progress bar ───────────────────────────────────────────────────────

  group('XP progress within level', () {
    test('Exactly at level threshold → 0.0 progress', () {
      // 400 XP = exactly level 2, start of band
      final p = GameProgress.fromXPAndStreak(400, 0);
      expect(p.xpProgress, equals(0.0));
    });

    test('Halfway through level band → ~0.5', () {
      // Level 2 band: 400–900 (500 XP wide). Midpoint = 650.
      final p = GameProgress.fromXPAndStreak(650, 0);
      expect(p.xpProgress, closeTo(0.5, 0.001));
    });
  });

  // ── Streak logic ──────────────────────────────────────────────────────────

  group('Streak calculation', () {
    test('Same day → streak maintained', () {
      final today = DateTime(2024, 6, 15);
      final result = GameProgressService.calculateNewStreak(
        currentStreak: 5,
        lastActivityDate: today,
        now: today,
      );
      expect(result, equals(5));
    });

    test('Consecutive day (+1 day) → streak incremented', () {
      final yesterday = DateTime(2024, 6, 14);
      final today     = DateTime(2024, 6, 15);
      final result = GameProgressService.calculateNewStreak(
        currentStreak: 4,
        lastActivityDate: yesterday,
        now: today,
      );
      expect(result, equals(5));
    });

    test('Skipping 48 hours (2-day gap) → streak reset to 1', () {
      final twoDaysAgo = DateTime(2024, 6, 13);
      final today      = DateTime(2024, 6, 15);
      final result = GameProgressService.calculateNewStreak(
        currentStreak: 7,
        lastActivityDate: twoDaysAgo,
        now: today,
      );
      expect(result, equals(1));
    });

    test('No prior activity → streak starts at 1', () {
      final result = GameProgressService.calculateNewStreak(
        currentStreak: 0,
        lastActivityDate: null,
        now: DateTime(2024, 6, 15),
      );
      expect(result, equals(1));
    });

    test('3-day gap → streak reset to 1', () {
      final threeDaysAgo = DateTime(2024, 6, 12);
      final today        = DateTime(2024, 6, 15);
      final result = GameProgressService.calculateNewStreak(
        currentStreak: 10,
        lastActivityDate: threeDaysAgo,
        now: today,
      );
      expect(result, equals(1));
    });
  });

  // ── Integration: processActivity via mock prefs ───────────────────────────

  group('GameProgressService.processActivity()', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Quiz activity adds 100 XP', () async {
      final service = GameProgressService();
      final result  = await service.processActivity(ActivityType.quiz);
      expect(result.totalXP, equals(100));
    });

    test('PlaceDiscovery activity adds 50 XP', () async {
      final service = GameProgressService();
      final result  = await service.processActivity(ActivityType.placeDiscovery);
      expect(result.totalXP, equals(50));
    });

    test('4 quiz activities → 400 XP → Level 2', () async {
      SharedPreferences.setMockInitialValues({});
      final service = GameProgressService();
      for (var i = 0; i < 4; i++) {
        await service.processActivity(ActivityType.quiz);
      }
      final result = await service.load();
      expect(result.totalXP, equals(400));
      expect(result.level,   equals(2));
    });
  });
}
