import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/gamification/domain/entities/user_progress.dart';
import '../../features/gamification/domain/entities/badge.dart';

class GamificationService {
  static const String _kUserProgressKey = 'user_progress_data';

  // ── XP Rewards ──────────────────────────────────────────────────────────────
  static const int xpDailyAppOpen = 10;          // first open of the day
  static const int xpQuizCompleted = 20;          // first-time quiz completion (per quizId)
  static const int xpQuizSessionBonus = 30;       // every completed quiz session
  static const int xpCorrectAnswer = 10;          // per correct answer
  static const int xpWrongAnswer = 2;             // participation reward per wrong answer
  static const int xpDailyFact = 5;              // "Did You Know" – once per day
  static const int xpMessageSent = 5;
  static const int xpFirstPersonalityInteraction = 10;
  static const int xpNewCategoryExplored = 20;

  // ── Badge IDs ────────────────────────────────────────────────────────────────
  static const String badgeFirstContact = 'first_contact';
  static const String badgeConversationalist = 'conversationalist';
  static const String badgeExplorer = 'explorer';
  static const String badgeScholar = 'scholar';
  static const String badgeHistorian = 'historian';

  final List<Badge> _availableBadges = [
    const Badge(
      id: badgeFirstContact,
      name: 'First Contact',
      description: 'Interact with your first historical personality.',
      icon: '🤝',
    ),
    const Badge(
      id: badgeConversationalist,
      name: 'Conversationalist',
      description: 'Send 50 messages to historical figures.',
      icon: '💬',
    ),
    const Badge(
      id: badgeExplorer,
      name: 'Explorer',
      description: 'Open all categories of personalities.',
      icon: '🌍',
    ),
    const Badge(
      id: badgeScholar,
      name: 'Scholar',
      description: 'Complete 5 interactive quizzes.',
      icon: '🎓',
    ),
    const Badge(
      id: badgeHistorian,
      name: 'Historian',
      description: 'Interact with 10 different personalities.',
      icon: '📜',
    ),
  ];

  // ── Core persistence ─────────────────────────────────────────────────────────

  Future<UserProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_kUserProgressKey);
    if (data == null) return const UserProgress();
    try {
      return UserProgress.fromJson(jsonDecode(data));
    } catch (_) {
      return const UserProgress();
    }
  }

  Future<void> saveProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserProgressKey, jsonEncode(progress.toJson()));
  }

  // ── Internal helper ──────────────────────────────────────────────────────────

  Future<UserProgress> _addXPAndSave(UserProgress progress, int amount) async {
    final newXP = progress.xp + amount;
    final updated = progress.copyWith(
      xp: newXP,
      level: UserProgress.calculateLevel(newXP),
    );
    await saveProgress(updated);
    return updated;
  }

  // ── Public XP actions ────────────────────────────────────────────────────────

  Future<UserProgress> addXP(int amount, {DateTime? customTime}) async {
    final progress = await loadProgress();
    return _addXPAndSave(progress, amount);
  }

  /// +10 XP per correct answer. Not idempotent — called once per answered question.
  Future<UserProgress> recordCorrectAnswer() async {
    final progress = await loadProgress();
    return _addXPAndSave(progress, xpCorrectAnswer);
  }

  /// +2 XP participation reward per wrong answer.
  Future<UserProgress> recordWrongAnswer() async {
    final progress = await loadProgress();
    return _addXPAndSave(progress, xpWrongAnswer);
  }

  /// +30 XP session bonus, awarded every time a quiz session is completed.
  Future<UserProgress> recordQuizSessionComplete() async {
    final progress = await loadProgress();
    return _addXPAndSave(progress, xpQuizSessionBonus);
  }

  /// +5 XP for viewing a "Did You Know" fact — awarded at most once per calendar day.
  Future<UserProgress> recordFactViewed({DateTime? customTime}) async {
    var progress = await loadProgress();
    final now = (customTime ?? DateTime.now()).toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);

    if (progress.lastFactDate != null) {
      final last = progress.lastFactDate!.toUtc();
      final lastDay = DateTime.utc(last.year, last.month, last.day);
      if (lastDay == today) return progress; // already rewarded today
    }

    final newXP = progress.xp + xpDailyFact;
    progress = progress.copyWith(
      xp: newXP,
      level: UserProgress.calculateLevel(newXP),
      lastFactDate: now,
    );
    await saveProgress(progress);
    return progress;
  }

  // ── Existing actions (preserved) ─────────────────────────────────────────────

  Future<UserProgress> recordMessageSent() async {
    var progress = await loadProgress();
    progress = progress.copyWith(
      xp: progress.xp + xpMessageSent,
      totalMessages: progress.totalMessages + 1,
    );
    progress = await _checkAndUnlockBadges(progress);
    progress = progress.copyWith(level: UserProgress.calculateLevel(progress.xp));
    await saveProgress(progress);
    return progress;
  }

  Future<UserProgress> recordPersonalityInteraction(String personalityId) async {
    var progress = await loadProgress();
    if (progress.interactedPersonalities.contains(personalityId)) return progress;

    final newList = List<String>.from(progress.interactedPersonalities)..add(personalityId);
    progress = progress.copyWith(
      xp: progress.xp + xpFirstPersonalityInteraction,
      interactedPersonalities: newList,
    );
    progress = await _checkAndUnlockBadges(progress);
    progress = progress.copyWith(level: UserProgress.calculateLevel(progress.xp));
    await saveProgress(progress);
    return progress;
  }

  Future<UserProgress> recordCategoryExplored(String categoryId) async {
    var progress = await loadProgress();
    if (progress.visitedCategories.contains(categoryId)) return progress;

    final newList = List<String>.from(progress.visitedCategories)..add(categoryId);
    progress = progress.copyWith(
      xp: progress.xp + xpNewCategoryExplored,
      visitedCategories: newList,
    );
    progress = await _checkAndUnlockBadges(progress);
    progress = progress.copyWith(level: UserProgress.calculateLevel(progress.xp));
    await saveProgress(progress);
    return progress;
  }

  /// +20 XP for completing a quiz for the first time (idempotent per quizId).
  Future<UserProgress> recordQuizCompleted(String quizId) async {
    var progress = await loadProgress();
    if (progress.completedQuizIds.contains(quizId)) return progress;

    final newList = List<String>.from(progress.completedQuizIds)..add(quizId);
    progress = progress.copyWith(
      xp: progress.xp + xpQuizCompleted,
      quizCount: progress.quizCount + 1,
      completedQuizIds: newList,
    );
    progress = await _checkAndUnlockBadges(progress);
    progress = progress.copyWith(level: UserProgress.calculateLevel(progress.xp));
    await saveProgress(progress);
    return progress;
  }

  /// Handles first daily app open: awards +10 XP and updates streak.
  Future<UserProgress> recordDailyOpen({DateTime? customTime}) async {
    var progress = await loadProgress();
    final now = (customTime ?? DateTime.now()).toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);

    if (progress.lastLoginDate != null) {
      final lastLoginUtc = progress.lastLoginDate!.toUtc();
      if (now.isBefore(lastLoginUtc)) return progress;

      final lastLoginDay = DateTime.utc(
        lastLoginUtc.year, lastLoginUtc.month, lastLoginUtc.day,
      );
      if (lastLoginDay == today) return progress;

      final diff = today.difference(lastLoginDay).inDays;
      final newStreak = diff == 1 ? progress.streakDays + 1 : 1;
      progress = progress.copyWith(
        xp: progress.xp + xpDailyAppOpen,
        lastLoginDate: now,
        streakDays: newStreak,
      );
    } else {
      progress = progress.copyWith(
        xp: progress.xp + xpDailyAppOpen,
        lastLoginDate: now,
        streakDays: 1,
      );
    }

    progress = progress.copyWith(level: UserProgress.calculateLevel(progress.xp));
    await saveProgress(progress);
    return progress;
  }

  // ── Badge logic ───────────────────────────────────────────────────────────────

  Future<UserProgress> _checkAndUnlockBadges(UserProgress progress) async {
    List<String> newlyUnlocked = List<String>.from(progress.unlockedBadges);
    bool changed = false;

    if (!newlyUnlocked.contains(badgeFirstContact) &&
        progress.interactedPersonalities.isNotEmpty) {
      newlyUnlocked.add(badgeFirstContact);
      changed = true;
    }
    if (!newlyUnlocked.contains(badgeConversationalist) &&
        progress.totalMessages >= 50) {
      newlyUnlocked.add(badgeConversationalist);
      changed = true;
    }
    if (!newlyUnlocked.contains(badgeExplorer) &&
        progress.visitedCategories.length >= 5) {
      newlyUnlocked.add(badgeExplorer);
      changed = true;
    }
    if (!newlyUnlocked.contains(badgeScholar) && progress.quizCount >= 5) {
      newlyUnlocked.add(badgeScholar);
      changed = true;
    }
    if (!newlyUnlocked.contains(badgeHistorian) &&
        progress.interactedPersonalities.length >= 10) {
      newlyUnlocked.add(badgeHistorian);
      changed = true;
    }

    return changed ? progress.copyWith(unlockedBadges: newlyUnlocked) : progress;
  }

  List<Badge> getBadges(List<String> unlockedIds) {
    return _availableBadges
        .map((b) => b.copyWith(isUnlocked: unlockedIds.contains(b.id)))
        .toList();
  }
}
