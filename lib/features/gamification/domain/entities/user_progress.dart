import 'dart:math';
import 'package:equatable/equatable.dart';

class UserProgress extends Equatable {
  final int xp;
  final int level;
  final List<String> unlockedBadges;
  final List<String> visitedCategories;
  final List<String> interactedPersonalities;
  final int totalMessages;
  final int quizCount;
  final DateTime? lastLoginDate;
  final int streakDays;

  const UserProgress({
    this.xp = 0,
    this.level = 1,
    this.unlockedBadges = const [],
    this.visitedCategories = const [],
    this.interactedPersonalities = const [],
    this.totalMessages = 0,
    this.quizCount = 0,
    this.lastLoginDate,
    this.streakDays = 0,
  });

  UserProgress copyWith({
    int? xp,
    int? level,
    List<String>? unlockedBadges,
    List<String>? visitedCategories,
    List<String>? interactedPersonalities,
    int? totalMessages,
    int? quizCount,
    DateTime? lastLoginDate,
    int? streakDays,
  }) {
    return UserProgress(
      xp: xp ?? this.xp,
      level: level ?? this.level,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
      visitedCategories: visitedCategories ?? this.visitedCategories,
      interactedPersonalities: interactedPersonalities ?? this.interactedPersonalities,
      totalMessages: totalMessages ?? this.totalMessages,
      quizCount: quizCount ?? this.quizCount,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  // Level formula: XP_required = 100 * (level ^ 1.5)
  static int calculateLevel(int xp) {
    if (xp < 100) return 1;
    // Reverse formula: level = (xp / 100) ^ (1 / 1.5)
    int level = pow(xp / 100, 2 / 3).floor();
    return max(1, level);
  }

  static int xpForLevel(int level) {
    if (level <= 1) return 0;
    return (100 * pow(level, 1.5)).floor();
  }

  double get progressToNextLevel {
    int currentLevelXP = xpForLevel(level);
    int nextLevelXP = xpForLevel(level + 1);
    if (nextLevelXP == currentLevelXP) return 0.0;
    return ((xp - currentLevelXP) / (nextLevelXP - currentLevelXP)).clamp(0.0, 1.0);
  }

  // Compatibility getters for legacy code
  double get xpProgress => progressToNextLevel;
  int get totalXP => xp;
  int get streak => streakDays;
  int get xpToNextLevel => xpForLevel(level + 1) - xp;
  
  String get rankLabel {
    if (level >= 20) return 'Legendary Historian';
    if (level >= 15) return 'Master Scholar';
    if (level >= 10) return 'Expert Explorer';
    if (level >= 5)  return 'Time Traveler';
    return 'Novice Explorer';
  }

  Map<String, dynamic> toJson() => {
    'xp': xp,
    'level': level,
    'unlockedBadges': unlockedBadges,
    'visitedCategories': visitedCategories,
    'interactedPersonalities': interactedPersonalities,
    'totalMessages': totalMessages,
    'quizCount': quizCount,
    'lastLoginDate': lastLoginDate?.toIso8601String(),
    'streakDays': streakDays,
  };

  factory UserProgress.fromJson(Map<String, dynamic> json) => UserProgress(
    xp: json['xp'] ?? 0,
    level: json['level'] ?? 1,
    unlockedBadges: List<String>.from(json['unlockedBadges'] ?? []),
    visitedCategories: List<String>.from(json['visitedCategories'] ?? []),
    interactedPersonalities: List<String>.from(json['interactedPersonalities'] ?? []),
    totalMessages: json['totalMessages'] ?? 0,
    quizCount: json['quizCount'] ?? 0,
    lastLoginDate: json['lastLoginDate'] != null ? DateTime.tryParse(json['lastLoginDate']) : null,
    streakDays: json['streakDays'] ?? 0,
  );

  @override
  List<Object?> get props => [
    xp,
    level,
    unlockedBadges,
    visitedCategories,
    interactedPersonalities,
    totalMessages,
    quizCount,
    lastLoginDate,
    streakDays,
  ];
}
