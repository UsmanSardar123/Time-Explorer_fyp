import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/gamification/data/services/mission_catalog.dart';
import '../../features/gamification/domain/entities/daily_mission.dart';
import '../../features/gamification/domain/entities/user_progress.dart';
import '../../features/gamification/domain/entities/badge.dart';

enum StreakStatus { normal, atRisk, broken }

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
  static const int xpPlaceDiscovered = 50;

  // ── Badge IDs ────────────────────────────────────────────────────────────────
  static const String badgeFirstContact = 'first_contact';
  static const String badgeConversationalist = 'conversationalist';
  static const String badgeExplorer = 'explorer';
  static const String badgeScholar = 'scholar';
  static const String badgeHistorian = 'historian';
  static const String badgeTrailblazer = 'trailblazer';
  static const String badgeArchaeologist = 'archaeologist';
  static const String badgeChronicler = 'chronicler';
  static const String badgeEpochMaster = 'epoch_master';
  static const String badgeQuizWhiz = 'quiz_whiz';
  static const String badgeQuestKeeper = 'quest_keeper';

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
    const Badge(
      id: badgeTrailblazer,
      name: 'Trailblazer',
      description: 'Explore 5 historical places.',
      icon: '🗺️',
    ),
    const Badge(
      id: badgeArchaeologist,
      name: 'Archaeologist',
      description: 'Explore 15 historical places.',
      icon: '⛏️',
    ),
    const Badge(
      id: badgeChronicler,
      name: 'Chronicler',
      description: 'Read 5 historical events.',
      icon: '📖',
    ),
    const Badge(
      id: badgeEpochMaster,
      name: 'Epoch Master',
      description: 'Read 15 historical events.',
      icon: '🏆',
    ),
    const Badge(
      id: badgeQuizWhiz,
      name: 'Quiz Whiz',
      description: 'Answer 10 quiz questions correctly.',
      icon: '🧠',
    ),
    const Badge(
      id: badgeQuestKeeper,
      name: 'Quest Keeper',
      description: 'Claim your first daily mission.',
      icon: '🎯',
    ),
  ];

  // ── Core persistence ─────────────────────────────────────────────────────────

  static const String _kFirestoreField = 'gamification';

  String? _getUserId() => FirebaseAuth.instance.currentUser?.uid;

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

  /// Loads progress from Firestore (source of truth), updates local cache, returns result.
  /// Falls back to local SharedPreferences on error.
  Future<UserProgress> loadFromFirestore(String uid) async {
    debugPrint('[GAMIFICATION] Fetching from Firestore for $uid');
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        final raw = doc.data()![_kFirestoreField];
        if (raw != null) {
          final progress = UserProgress.fromJson(Map<String, dynamic>.from(raw));
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_kUserProgressKey, jsonEncode(progress.toJson()));
          debugPrint('[GAMIFICATION] Firestore sync done: xp=${progress.xp}, level=${progress.level}, streak=${progress.streakDays}');
          return progress;
        }
      }
    } catch (e) {
      debugPrint('[GAMIFICATION] Firestore load error (using local): $e');
    }
    return loadProgress();
  }

  /// Fire-and-forget Firestore write — does not block callers.
  void _syncToFirestore(UserProgress progress) {
    final uid = _getUserId();
    if (uid == null) return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
          _kFirestoreField: progress.toJson(),
          'xp': progress.xp,
          'level': progress.level,
          'streak': progress.streakDays,
          'lastActive': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true))
        .then((_) => debugPrint('[GAMIFICATION] Firestore write ok: xp=${progress.xp}, streak=${progress.streakDays}'))
        .catchError((e) => debugPrint('[GAMIFICATION] Firestore write failed: $e'));
  }

  Future<void> saveProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserProgressKey, jsonEncode(progress.toJson()));
    _syncToFirestore(progress); // non-blocking background sync
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

  /// Ensures [progress] has today's mission set; rotates if stale.
  /// Pure — does not persist; callers save via the existing flow.
  UserProgress _ensureMission(UserProgress progress) {
    final today = MissionCatalog.todayKey();
    if (progress.dailyMission?.dateKey == today) return progress;
    return progress.copyWith(
      dailyMission: MissionCatalog.missionFor(DateTime.now().toUtc()),
    );
  }

  /// Increments mission progress in-place when today's mission matches [taskKey].
  /// No-op otherwise. Pure — caller saves.
  UserProgress _bumpMission(UserProgress progress, String taskKey,
      [int amount = 1]) {
    final m = progress.dailyMission;
    if (m == null) return progress;
    if (m.dateKey != MissionCatalog.todayKey()) return progress;
    if (m.taskKey != taskKey) return progress;
    if (m.progress >= m.target) return progress;
    final next = (m.progress + amount).clamp(0, m.target);
    return progress.copyWith(dailyMission: m.copyWith(progress: next));
  }

  // ── Public XP actions ────────────────────────────────────────────────────────

  Future<UserProgress> addXP(int amount, {DateTime? customTime}) async {
    final progress = await loadProgress();
    return _addXPAndSave(progress, amount);
  }

  /// +10 XP per correct answer. Not idempotent — called once per answered question.
  Future<UserProgress> recordCorrectAnswer() async {
    var progress = await loadProgress();
    progress = _bumpMission(progress, MissionCatalog.taskAnswerQuiz);
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
    progress = _bumpMission(progress, MissionCatalog.taskViewFact);
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

  /// +50 XP for discovering a place for the first time (idempotent per placeId).
  Future<UserProgress> recordPlaceDiscovered(String placeId) async {
    var progress = await loadProgress();
    if (progress.exploredPlaceIds.contains(placeId)) return progress;

    final newList = List<String>.from(progress.exploredPlaceIds)..add(placeId);
    progress = progress.copyWith(
      xp: progress.xp + xpPlaceDiscovered,
      exploredPlaceIds: newList,
    );
    progress = await _checkAndUnlockBadges(progress);
    progress = _bumpMission(progress, MissionCatalog.taskDiscoverPlaces);
    progress = progress.copyWith(level: UserProgress.calculateLevel(progress.xp));
    await saveProgress(progress);
    return progress;
  }

  /// +15 XP for viewing an event for the first time (idempotent per eventId).
  Future<UserProgress> recordEventCompleted(String eventId) async {
    var progress = await loadProgress();
    if (progress.completedEventIds.contains(eventId)) return progress;

    final newList = List<String>.from(progress.completedEventIds)..add(eventId);
    progress = progress.copyWith(
      xp: progress.xp + 15,
      completedEventIds: newList,
    );
    progress = _bumpMission(progress, MissionCatalog.taskExploreEvents);
    progress = await _checkAndUnlockBadges(progress);
    progress = progress.copyWith(level: UserProgress.calculateLevel(progress.xp));
    await saveProgress(progress);
    return progress;
  }

  /// Records the answer to a single mini-quiz question. Awards
  /// [xpCorrectAnswer] XP only on the FIRST correct answer per [questionId].
  /// Wrong answers do not consume the question — the user can retry.
  Future<UserProgress> recordEventQuizAnswer({
    required String questionId,
    required bool isCorrect,
  }) async {
    var progress = await loadProgress();
    if (progress.answeredQuestionIds.contains(questionId)) return progress;
    if (!isCorrect) return progress;

    final newList = List<String>.from(progress.answeredQuestionIds)
      ..add(questionId);
    progress = progress.copyWith(
      xp: progress.xp + xpCorrectAnswer,
      answeredQuestionIds: newList,
    );
    progress = _bumpMission(progress, MissionCatalog.taskAnswerQuiz);
    progress = await _checkAndUnlockBadges(progress);
    progress = progress.copyWith(
      level: UserProgress.calculateLevel(progress.xp),
    );
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

  /// Returns streak risk level based on hours since last login.
  /// Call BEFORE recordDailyOpen() to read the pre-update status.
  StreakStatus checkStreakStatus(UserProgress progress, {DateTime? customTime}) {
    if (progress.lastLoginDate == null) return StreakStatus.normal;
    final now = customTime ?? DateTime.now();
    final gapHours = now.difference(progress.lastLoginDate!.toLocal()).inHours;
    if (gapHours > 24) return StreakStatus.broken;
    if (gapHours >= 18) return StreakStatus.atRisk;
    return StreakStatus.normal;
  }

  /// Handles first daily app open: awards +10 XP and updates streak.
  /// [baseProgress] skips the SharedPreferences read and uses the provided value directly.
  Future<UserProgress> recordDailyOpen({DateTime? customTime, UserProgress? baseProgress}) async {
    var progress = baseProgress ?? await loadProgress();
    final now = (customTime ?? DateTime.now()).toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);

    if (progress.lastLoginDate != null) {
      final lastLoginUtc = progress.lastLoginDate!.toUtc();
      if (now.isBefore(lastLoginUtc)) return progress;

      final lastLoginDay = DateTime.utc(
        lastLoginUtc.year, lastLoginUtc.month, lastLoginUtc.day,
      );
      if (lastLoginDay == today) {
        final rotated = _ensureMission(progress);
        if (rotated != progress) {
          await saveProgress(rotated);
          return rotated;
        }
        return progress;
      }

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

    progress = _ensureMission(progress);
    progress = progress.copyWith(level: UserProgress.calculateLevel(progress.xp));
    await saveProgress(progress);
    return progress;
  }

  /// Awards the daily mission's reward XP and marks it claimed. Idempotent —
  /// calling twice for the same mission returns unchanged progress.
  Future<UserProgress> claimDailyMissionReward() async {
    var progress = await loadProgress();
    final m = progress.dailyMission;
    if (m == null) return progress;
    if (m.dateKey != MissionCatalog.todayKey()) return progress;
    if (!m.completed || m.claimed) return progress;

    final newXP = progress.xp + m.rewardXp;
    progress = progress.copyWith(
      xp: newXP,
      level: UserProgress.calculateLevel(newXP),
      dailyMission: m.copyWith(claimed: true),
    );
    progress = await _checkAndUnlockBadges(progress);
    await saveProgress(progress);
    return progress;
  }

  /// Returns today's mission, ensuring rotation if stale. Pure read — no save.
  DailyMission missionFor(UserProgress progress) {
    final today = MissionCatalog.todayKey();
    final m = progress.dailyMission;
    if (m != null && m.dateKey == today) return m;
    return MissionCatalog.missionFor(DateTime.now().toUtc());
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
    if (!newlyUnlocked.contains(badgeTrailblazer) &&
        progress.exploredPlaceIds.length >= 5) {
      newlyUnlocked.add(badgeTrailblazer);
      changed = true;
    }
    if (!newlyUnlocked.contains(badgeArchaeologist) &&
        progress.exploredPlaceIds.length >= 15) {
      newlyUnlocked.add(badgeArchaeologist);
      changed = true;
    }
    if (!newlyUnlocked.contains(badgeChronicler) &&
        progress.completedEventIds.length >= 5) {
      newlyUnlocked.add(badgeChronicler);
      changed = true;
    }
    if (!newlyUnlocked.contains(badgeEpochMaster) &&
        progress.completedEventIds.length >= 15) {
      newlyUnlocked.add(badgeEpochMaster);
      changed = true;
    }
    if (!newlyUnlocked.contains(badgeQuizWhiz) &&
        progress.answeredQuestionIds.length >= 10) {
      newlyUnlocked.add(badgeQuizWhiz);
      changed = true;
    }
    if (!newlyUnlocked.contains(badgeQuestKeeper) &&
        (progress.dailyMission?.claimed ?? false)) {
      newlyUnlocked.add(badgeQuestKeeper);
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
