import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeexplorer/core/services/gamification_service.dart';
import 'package:timeexplorer/features/gamification/domain/entities/user_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late GamificationService service;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    service = GamificationService();
  });

  group('GamificationService - Streak Logic (UTC)', () {
    test('First login sets streak to 1', () async {
      final now = DateTime.utc(2023, 10, 1, 12);
      final progress = await service.recordDailyOpen(customTime: now);
      
      expect(progress.streakDays, 1);
      expect(progress.lastLoginDate?.toUtc(), now);
    });

    test('Login on consecutive days increments streak', () async {
      final day1 = DateTime.utc(2023, 10, 1, 23); // Late at night
      await service.recordDailyOpen(customTime: day1);
      
      final day2 = DateTime.utc(2023, 10, 2, 1); // Early next morning (still consecutive)
      final progress = await service.recordDailyOpen(customTime: day2);
      
      expect(progress.streakDays, 2);
    });

    test('Login on same UTC day does not change streak or award XP twice', () async {
      final day1 = DateTime.utc(2023, 10, 1, 10);
      final p1 = await service.recordDailyOpen(customTime: day1);
      final xp1 = p1.xp;
      
      final day1Later = DateTime.utc(2023, 10, 1, 15);
      final p2 = await service.recordDailyOpen(customTime: day1Later);
      
      expect(p2.streakDays, 1);
      expect(p2.xp, xp1); // Idempotent
    });

    test('Gap of more than 1 day resets streak to 1', () async {
      final day1 = DateTime.utc(2023, 10, 1, 10);
      await service.recordDailyOpen(customTime: day1);
      
      final day3 = DateTime.utc(2023, 10, 3, 10); // Skipped Oct 2
      final progress = await service.recordDailyOpen(customTime: day3);
      
      expect(progress.streakDays, 1);
    });

    test('Simulation: 7-day consecutive usage', () async {
      for (int i = 0; i < 7; i++) {
        final day = DateTime.utc(2023, 10, 1 + i, 12);
        final progress = await service.recordDailyOpen(customTime: day);
        expect(progress.streakDays, i + 1);
      }
    });

    test('Timezone Change: Local time changes but UTC day remains same', () async {
      // User opens app at 23:00 UTC (Local 4:00 AM)
      final time1 = DateTime.utc(2023, 10, 1, 23);
      await service.recordDailyOpen(customTime: time1);
      
      // User flies west, Local time is now earlier, but it's still Oct 1st 23:59 UTC
      final time2 = DateTime.utc(2023, 10, 1, 23, 59);
      final progress = await service.recordDailyOpen(customTime: time2);
      
      expect(progress.streakDays, 1); // Should NOT increment or reset, same UTC day
    });

    test('Exploit Protection: Back-dating system clock', () async {
      final today = DateTime.utc(2023, 10, 5, 12);
      await service.recordDailyOpen(customTime: today);
      
      // User tries to change clock back to Oct 1st
      final backDate = DateTime.utc(2023, 10, 1, 12);
      final progress = await service.recordDailyOpen(customTime: backDate);
      
      // Should ignore the older date and keep the current state
      expect(progress.lastLoginDate?.toUtc(), today);
      expect(progress.streakDays, 1);
    });
  });

  group('GamificationService - XP & Leveling', () {
    test('Multiple level-ups in a single XP gain', () async {
      // Starting from 0 XP (Level 1)
      // Awarding 1000 XP should skip Level 2 (100) and Level 3 (400) and land on Level 4 (900)
      final progress = await service.addXP(1000);
      expect(progress.level, 4);
    });
    test('recordQuizCompleted should only award XP once for the same quiz ID', () async {
      const quizId = 'test_quiz_1';
      
      final p1 = await service.recordQuizCompleted(quizId);
      final xpAfterFirst = p1.xp;
      expect(p1.completedQuizIds.contains(quizId), true);
      
      final p2 = await service.recordQuizCompleted(quizId);
      expect(p2.xp, xpAfterFirst); // Should not increase
      expect(p2.completedQuizIds.length, 1);
    });

    test('recordPersonalityInteraction should only award XP once per personality', () async {
      const pId = 'einstein';
      
      final progress1 = await service.recordPersonalityInteraction(pId);
      final xp1 = progress1.xp;
      
      final progress2 = await service.recordPersonalityInteraction(pId);
      expect(progress2.xp, xp1);
    });
  });
}
