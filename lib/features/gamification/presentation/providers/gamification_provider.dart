import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/gamification_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/daily_mission.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/entities/badge.dart';
import '../../domain/entities/game_progress.dart';

class GamificationProvider extends ChangeNotifier {
  final GamificationService _service;

  GamificationProvider({GamificationService? service})
      : _service = service ?? GamificationService();

  UserProgress _progress = const UserProgress();
  bool _pendingLevelUp = false;
  String? _newlyUnlockedBadge;
  bool _isInitializing = true;
  bool _initCalled = false;
  StreamSubscription<User?>? _authSubscription;
  String? _lastSyncedUid;

  UserProgress get progress => _progress;
  bool get pendingLevelUp => _pendingLevelUp;
  String? get newlyUnlockedBadge => _newlyUnlockedBadge;
  bool get isInitializing => _isInitializing;

  List<Badge> get badges => _service.getBadges(_progress.unlockedBadges);

  Future<void> init() async {
    if (_initCalled) return;
    _initCalled = true;
    await _migrateOldData();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      debugPrint('[GAMIFICATION] Init: syncing Firestore for $uid');
      _progress = await _service.loadFromFirestore(uid);
      _lastSyncedUid = uid;
    }

    await _doOpenAndNotify();

    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        _lastSyncedUid = null;
        return;
      }
      if (user.uid == _lastSyncedUid) return;
      _lastSyncedUid = user.uid;
      debugPrint('[GAMIFICATION] Auth change: syncing Firestore for ${user.uid}');
      _progress = await _service.loadFromFirestore(user.uid);
      await _doOpenAndNotify();
    });
  }

  Future<void> _doOpenAndNotify() async {
    final streakStatus = _service.checkStreakStatus(_progress);
    final oldXP = _progress.xp;
    final oldLevel = _progress.level;
    final gapDays = _progress.lastLoginDate != null
        ? DateTime.now().difference(_progress.lastLoginDate!).inDays
        : 0;

    _progress = await _service.recordDailyOpen();
    _isInitializing = false;
    notifyListeners();

    // Fire-and-forget notification triggers
    _triggerOpenNotifications(
      streakStatus: streakStatus,
      oldXP: oldXP,
      newXP: _progress.xp,
      oldLevel: oldLevel,
      newLevel: _progress.level,
      gapDays: gapDays,
    );
  }

  void _triggerOpenNotifications({
    required StreakStatus streakStatus,
    required int oldXP,
    required int newXP,
    required int oldLevel,
    required int newLevel,
    required int gapDays,
  }) {
    if (streakStatus == StreakStatus.broken) {
      NotificationService.showStreakBroken();
      if (gapDays >= 3) NotificationService.showInactivityReminder(gapDays);
    } else if (streakStatus == StreakStatus.atRisk) {
      NotificationService.showStreakWarning(_progress.streakDays);
    } else if (gapDays >= 1) {
      NotificationService.showInactivityReminder(gapDays);
    }

    if (newXP > oldXP) {
      NotificationService.showXPEarned(newXP - oldXP);
    }

    if (newLevel > oldLevel) {
      NotificationService.showLevelUp(newLevel, _progress.rankLabel);
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _migrateOldData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_progress_data')) return;
    final oldXP = prefs.getInt('gam_total_xp');
    final oldStreak = prefs.getInt('gam_streak');
    if (oldXP != null || oldStreak != null) {
      _progress = UserProgress(
        xp: oldXP ?? 0,
        streakDays: oldStreak ?? 0,
        level: UserProgress.calculateLevel(oldXP ?? 0),
      );
      await _service.saveProgress(_progress);
    }
  }

  // ── Existing actions ──────────────────────────────────────────────────────────

  Future<void> recordMessageSent() async {
    final oldLevel = _progress.level;
    final oldBadges = List<String>.from(_progress.unlockedBadges);
    _progress = await _service.recordMessageSent();
    _checkMilestones(oldLevel, oldBadges);
    notifyListeners();
  }

  Future<void> recordPersonalityInteraction(String personalityId) async {
    final oldLevel = _progress.level;
    final oldBadges = List<String>.from(_progress.unlockedBadges);
    _progress = await _service.recordPersonalityInteraction(personalityId);
    _checkMilestones(oldLevel, oldBadges);
    notifyListeners();
  }

  Future<void> recordCategoryExplored(String categoryId) async {
    final oldLevel = _progress.level;
    final oldBadges = List<String>.from(_progress.unlockedBadges);
    _progress = await _service.recordCategoryExplored(categoryId);
    _checkMilestones(oldLevel, oldBadges);
    notifyListeners();
  }

  Future<void> recordQuizCompleted(String quizId) async {
    final oldLevel = _progress.level;
    final oldBadges = List<String>.from(_progress.unlockedBadges);
    _progress = await _service.recordQuizCompleted(quizId);
    _checkMilestones(oldLevel, oldBadges);
    notifyListeners();
  }

  Future<void> recordEventCompleted(String eventId) async {
    final oldLevel = _progress.level;
    _progress = await _service.recordEventCompleted(eventId);
    if (_progress.level > oldLevel) _checkMilestones(oldLevel, []);
    notifyListeners();
  }

  /// Records a mini-quiz answer. Idempotent: XP is awarded only on the
  /// first correct response per question. Returns true if XP was awarded
  /// (so the UI can show a celebration).
  Future<bool> recordEventQuizAnswer({
    required String questionId,
    required bool isCorrect,
  }) async {
    final wasNew = !_progress.answeredQuestionIds.contains(questionId);
    final oldXP = _progress.xp;
    final oldLevel = _progress.level;
    _progress = await _service.recordEventQuizAnswer(
      questionId: questionId,
      isCorrect: isCorrect,
    );
    final awarded = _progress.xp > oldXP;
    if (awarded) {
      NotificationService.showXPEarned(_progress.xp - oldXP);
      if (_progress.level > oldLevel) _checkMilestones(oldLevel, []);
    }
    notifyListeners();
    return awarded && wasNew;
  }


  // ── Granular XP actions ───────────────────────────────────────────────────────

  Future<void> recordCorrectAnswer() async {
    final oldLevel = _progress.level;
    _progress = await _service.recordCorrectAnswer();
    if (_progress.level > oldLevel) {
      _pendingLevelUp = true;
      NotificationService.showLevelUp(_progress.level, _progress.rankLabel);
    }
    notifyListeners();
  }

  Future<void> recordWrongAnswer() async {
    _progress = await _service.recordWrongAnswer();
    notifyListeners();
  }

  Future<void> recordQuizSessionComplete() async {
    final oldLevel = _progress.level;
    final oldBadges = List<String>.from(_progress.unlockedBadges);
    final oldXP = _progress.xp;
    _progress = await _service.recordQuizSessionComplete();
    _checkMilestones(oldLevel, oldBadges);
    if (_progress.xp > oldXP) {
      NotificationService.showXPEarned(_progress.xp - oldXP);
    }
    notifyListeners();
  }

  Future<void> recordPlaceDiscovered(String placeId) async {
    final oldLevel = _progress.level;
    final oldBadges = List<String>.from(_progress.unlockedBadges);
    final oldXP = _progress.xp;
    _progress = await _service.recordPlaceDiscovered(placeId);
    _checkMilestones(oldLevel, oldBadges);
    if (_progress.xp > oldXP) {
      NotificationService.showXPEarned(_progress.xp - oldXP);
    }
    notifyListeners();
  }

  Future<void> recordFactViewed() async {
    final oldLevel = _progress.level;
    _progress = await _service.recordFactViewed();
    if (_progress.level > oldLevel) {
      _pendingLevelUp = true;
      NotificationService.showLevelUp(_progress.level, _progress.rankLabel);
    }
    notifyListeners();
  }

  // ── Daily missions ───────────────────────────────────────────────────────────

  DailyMission get dailyMission => _service.missionFor(_progress);

  Future<bool> claimDailyMissionReward() async {
    final oldXP = _progress.xp;
    final oldLevel = _progress.level;
    _progress = await _service.claimDailyMissionReward();
    final awarded = _progress.xp > oldXP;
    if (awarded) {
      NotificationService.showXPEarned(_progress.xp - oldXP);
      if (_progress.level > oldLevel) _checkMilestones(oldLevel, []);
    }
    notifyListeners();
    return awarded;
  }

  // ── Milestone detection ───────────────────────────────────────────────────────

  void _checkMilestones(int oldLevel, List<String> oldBadges) {
    if (_progress.level > oldLevel) {
      _pendingLevelUp = true;
      NotificationService.showLevelUp(_progress.level, _progress.rankLabel);
    }
    for (final bId in _progress.unlockedBadges) {
      if (!oldBadges.contains(bId)) {
        _newlyUnlockedBadge = bId;
        final allBadges = _service.getBadges([]);
        final badge = allBadges.firstWhere(
          (b) => b.id == bId,
          orElse: () => const Badge(
            id: '',
            name: 'Achievement',
            description: '',
            icon: '🏆',
          ),
        );
        NotificationService.showBadgeUnlocked(badge.name, badge.icon);
        break;
      }
    }
  }

  void clearLevelUp() {
    _pendingLevelUp = false;
    notifyListeners();
  }

  void clearBadgeUnlock() {
    _newlyUnlockedBadge = null;
    notifyListeners();
  }

  // ── Backward-compatibility ────────────────────────────────────────────────────

  Future<void> awardXP(int amount) async {
    final oldLevel = _progress.level;
    _progress = await _service.addXP(amount);
    if (_progress.level > oldLevel) _pendingLevelUp = true;
    notifyListeners();
  }

  Future<void> processActivity(dynamic activity) async {
    if (activity is int) {
      await awardXP(activity);
    } else if (activity is ActivityType) {
      switch (activity) {
        case ActivityType.placeDiscovery:
          await recordFactViewed();
        case ActivityType.quiz:
          await recordQuizSessionComplete();
      }
    }
  }
}
