import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/gamification_service.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/entities/badge.dart';

class GamificationProvider extends ChangeNotifier {
  final GamificationService _service;

  GamificationProvider({GamificationService? service})
      : _service = service ?? GamificationService();

  UserProgress _progress = const UserProgress();
  bool _pendingLevelUp = false;
  String? _newlyUnlockedBadge;

  UserProgress get progress => _progress;
  bool get pendingLevelUp => _pendingLevelUp;
  String? get newlyUnlockedBadge => _newlyUnlockedBadge;

  List<Badge> get badges => _service.getBadges(_progress.unlockedBadges);

  Future<void> init() async {
    await _migrateOldData();
    _progress = await _service.recordDailyOpen();
    notifyListeners();
  }

  Future<void> _migrateOldData() async {
    final prefs = await SharedPreferences.getInstance();
    // Check if new data already exists
    if (prefs.containsKey('user_progress_data')) return;

    // Try to migrate from old keys
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

  Future<void> recordQuizCompleted() async {
    final oldLevel = _progress.level;
    final oldBadges = List<String>.from(_progress.unlockedBadges);
    
    _progress = await _service.recordQuizCompleted();
    
    _checkMilestones(oldLevel, oldBadges);
    notifyListeners();
  }

  void _checkMilestones(int oldLevel, List<String> oldBadges) {
    if (_progress.level > oldLevel) {
      _pendingLevelUp = true;
    }
    
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

  // Backward compatibility aliases
  Future<void> awardXP(int amount) async {
    final oldLevel = _progress.level;
    _progress = await _service.addXP(amount);
    if (_progress.level > oldLevel) {
      _pendingLevelUp = true;
    }
    notifyListeners();
  }

  Future<void> processActivity(dynamic activity) async {
    // Basic implementation for compatibility
    if (activity is int) {
      await awardXP(activity);
    }
  }
}
