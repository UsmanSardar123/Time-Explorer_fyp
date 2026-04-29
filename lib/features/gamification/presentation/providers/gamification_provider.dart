import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/gamification_service.dart';
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

  UserProgress get progress => _progress;
  bool get pendingLevelUp => _pendingLevelUp;
  String? get newlyUnlockedBadge => _newlyUnlockedBadge;
  bool get isInitializing => _isInitializing;

  List<Badge> get badges => _service.getBadges(_progress.unlockedBadges);

  Future<void> init() async {
    if (_initCalled) return;
    _initCalled = true;
    await _migrateOldData();
    _progress = await _service.recordDailyOpen();
    _isInitializing = false;
    notifyListeners();
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

  // ── Existing actions ─────────────────────────────────────────────────────────

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

  /// Idempotent – only awards +20 XP the first time this quizId is completed.
  Future<void> recordQuizCompleted(String quizId) async {
    final oldLevel = _progress.level;
    final oldBadges = List<String>.from(_progress.unlockedBadges);
    _progress = await _service.recordQuizCompleted(quizId);
    _checkMilestones(oldLevel, oldBadges);
    notifyListeners();
  }

  // ── New granular actions ──────────────────────────────────────────────────────

  /// +10 XP – call once per correct quiz answer.
  Future<void> recordCorrectAnswer() async {
    final oldLevel = _progress.level;
    _progress = await _service.recordCorrectAnswer();
    if (_progress.level > oldLevel) _pendingLevelUp = true;
    notifyListeners();
  }

  /// +2 XP participation reward – call once per wrong quiz answer.
  Future<void> recordWrongAnswer() async {
    _progress = await _service.recordWrongAnswer();
    notifyListeners();
  }

  /// +30 XP session bonus – call once when a full quiz session is completed.
  Future<void> recordQuizSessionComplete() async {
    final oldLevel = _progress.level;
    final oldBadges = List<String>.from(_progress.unlockedBadges);
    _progress = await _service.recordQuizSessionComplete();
    _checkMilestones(oldLevel, oldBadges);
    notifyListeners();
  }

  /// +50 XP – call the first time a place is opened (idempotent per placeId).
  Future<void> recordPlaceDiscovered(String placeId) async {
    final oldLevel = _progress.level;
    final oldBadges = List<String>.from(_progress.unlockedBadges);
    _progress = await _service.recordPlaceDiscovered(placeId);
    _checkMilestones(oldLevel, oldBadges);
    notifyListeners();
  }

  /// +5 XP – call when user views a "Did You Know" fact (once per day).
  Future<void> recordFactViewed() async {
    final oldLevel = _progress.level;
    _progress = await _service.recordFactViewed();
    if (_progress.level > oldLevel) _pendingLevelUp = true;
    notifyListeners();
  }

  // ── Milestone detection ───────────────────────────────────────────────────────

  void _checkMilestones(int oldLevel, List<String> oldBadges) {
    if (_progress.level > oldLevel) _pendingLevelUp = true;
    for (final bId in _progress.unlockedBadges) {
      if (!oldBadges.contains(bId)) {
        _newlyUnlockedBadge = bId;
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

  /// Handles both raw int amounts and ActivityType enum values.
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
