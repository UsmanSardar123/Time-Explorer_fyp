import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/gamification/domain/entities/user_progress.dart';
import '../../features/gamification/domain/entities/badge.dart';

class GamificationService {
  static const String _kUserProgressKey = 'user_progress_data';
  
  // XP Rewards
  static const int xpMessageSent = 5;
  static const int xpFirstPersonalityInteraction = 10;
  static const int xpQuizCompleted = 25;
  static const int xpNewCategoryExplored = 20;
  static const int xpDailyAppOpen = 5;

  // Badge IDs
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

  Future<UserProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_kUserProgressKey);
    if (data == null) return const UserProgress();
    try {
      return UserProgress.fromJson(jsonDecode(data));
    } catch (e) {
      return const UserProgress();
    }
  }

  Future<void> saveProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserProgressKey, jsonEncode(progress.toJson()));
  }

  Future<UserProgress> addXP(int amount) async {
    var progress = await loadProgress();
    int newXP = progress.xp + amount;
    int newLevel = UserProgress.calculateLevel(newXP);
    
    progress = progress.copyWith(
      xp: newXP,
      level: newLevel,
    );
    
    await saveProgress(progress);
    return progress;
  }

  Future<UserProgress> recordMessageSent() async {
    var progress = await loadProgress();
    int newTotalMessages = progress.totalMessages + 1;
    
    progress = progress.copyWith(
      xp: progress.xp + xpMessageSent,
      totalMessages: newTotalMessages,
    );
    
    progress = await _checkAndUnlockBadges(progress);
    progress = progress.copyWith(level: UserProgress.calculateLevel(progress.xp));
    
    await saveProgress(progress);
    return progress;
  }

  Future<UserProgress> recordPersonalityInteraction(String personalityId) async {
    var progress = await loadProgress();
    
    if (progress.interactedPersonalities.contains(personalityId)) {
      return progress;
    }
    
    final newList = List<String>.from(progress.interactedPersonalities)..add(personalityId);
    int bonusXP = xpFirstPersonalityInteraction;
    
    progress = progress.copyWith(
      xp: progress.xp + bonusXP,
      interactedPersonalities: newList,
    );
    
    progress = await _checkAndUnlockBadges(progress);
    progress = progress.copyWith(level: UserProgress.calculateLevel(progress.xp));
    
    await saveProgress(progress);
    return progress;
  }

  Future<UserProgress> recordCategoryExplored(String categoryId) async {
    var progress = await loadProgress();
    
    if (progress.visitedCategories.contains(categoryId)) {
      return progress;
    }
    
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

  Future<UserProgress> recordQuizCompleted() async {
    var progress = await loadProgress();
    int newQuizCount = progress.quizCount + 1;
    
    progress = progress.copyWith(
      xp: progress.xp + xpQuizCompleted,
      quizCount: newQuizCount,
    );
    
    progress = await _checkAndUnlockBadges(progress);
    progress = progress.copyWith(level: UserProgress.calculateLevel(progress.xp));
    
    await saveProgress(progress);
    return progress;
  }

  Future<UserProgress> recordDailyOpen() async {
    var progress = await loadProgress();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (progress.lastLoginDate != null) {
      final lastLogin = DateTime(
        progress.lastLoginDate!.year,
        progress.lastLoginDate!.month,
        progress.lastLoginDate!.day,
      );
      
      if (lastLogin == today) return progress;
      
      final difference = today.difference(lastLogin).inDays;
      int newStreak = 1;
      if (difference == 1) {
        newStreak = progress.streakDays + 1;
      }
      
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

  Future<UserProgress> _checkAndUnlockBadges(UserProgress progress) async {
    List<String> newlyUnlocked = List<String>.from(progress.unlockedBadges);
    bool changed = false;

    // First Contact
    if (!newlyUnlocked.contains(badgeFirstContact) && progress.interactedPersonalities.isNotEmpty) {
      newlyUnlocked.add(badgeFirstContact);
      changed = true;
    }

    // Conversationalist
    if (!newlyUnlocked.contains(badgeConversationalist) && progress.totalMessages >= 50) {
      newlyUnlocked.add(badgeConversationalist);
      changed = true;
    }

    // Explorer (assuming 5 categories as per categories_page.dart's _availableCategories)
    if (!newlyUnlocked.contains(badgeExplorer) && progress.visitedCategories.length >= 5) {
      newlyUnlocked.add(badgeExplorer);
      changed = true;
    }

    // Scholar
    if (!newlyUnlocked.contains(badgeScholar) && progress.quizCount >= 5) {
      newlyUnlocked.add(badgeScholar);
      changed = true;
    }

    // Historian
    if (!newlyUnlocked.contains(badgeHistorian) && progress.interactedPersonalities.length >= 10) {
      newlyUnlocked.add(badgeHistorian);
      changed = true;
    }

    if (changed) {
      return progress.copyWith(unlockedBadges: newlyUnlocked);
    }
    return progress;
  }

  List<Badge> getBadges(List<String> unlockedIds) {
    return _availableBadges.map((b) => b.copyWith(isUnlocked: unlockedIds.contains(b.id))).toList();
  }
}
