import 'dart:math';
import 'package:equatable/equatable.dart';
import 'daily_mission.dart';

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
  final List<String> completedQuizIds;
  final DateTime? lastFactDate;
  final List<String> exploredPlaceIds;
  final List<String> completedEventIds;
  final List<String> answeredQuestionIds;
  final DailyMission? dailyMission;

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
    this.completedQuizIds = const [],
    this.lastFactDate,
    this.exploredPlaceIds = const [],
    this.completedEventIds = const [],
    this.answeredQuestionIds = const [],
    this.dailyMission,
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
    List<String>? completedQuizIds,
    DateTime? lastFactDate,
    List<String>? exploredPlaceIds,
    List<String>? completedEventIds,
    List<String>? answeredQuestionIds,
    DailyMission? dailyMission,
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
      completedQuizIds: completedQuizIds ?? this.completedQuizIds,
      lastFactDate: lastFactDate ?? this.lastFactDate,
      exploredPlaceIds: exploredPlaceIds ?? this.exploredPlaceIds,
      completedEventIds: completedEventIds ?? this.completedEventIds,
      answeredQuestionIds: answeredQuestionIds ?? this.answeredQuestionIds,
      dailyMission: dailyMission ?? this.dailyMission,
    );
  }

  // Level formula: XP to advance from level n to n+1 = floor(100 × n^1.5)
  // Cumulative XP to reach level n: sum_{k=1}^{n-1} floor(100 × k^1.5)
  //   Level 1 →    0 XP
  //   Level 2 →  100 XP  (100 × 1^1.5 = 100)
  //   Level 3 →  383 XP  (+283)
  //   Level 4 →  903 XP  (+520)
  static int xpForLevel(int level) {
    if (level <= 1) return 0;
    int total = 0;
    for (int k = 1; k < level; k++) {
      total += (100 * pow(k, 1.5)).toInt();
    }
    return total;
  }

  static int calculateLevel(int xp) {
    if (xp <= 0) return 1;
    int level = 1;
    while (xpForLevel(level + 1) <= xp) {
      level++;
    }
    return level;
  }

  double get progressToNextLevel {
    final currentLevelXP = xpForLevel(level);
    final nextLevelXP = xpForLevel(level + 1);
    if (nextLevelXP <= currentLevelXP) return 0.0;
    return ((xp - currentLevelXP) / (nextLevelXP - currentLevelXP)).clamp(0.0, 1.0);
  }

  // Compatibility getters for legacy code
  double get xpProgress => progressToNextLevel;
  int get totalXP => xp;
  int get streak => streakDays;
  int get xpToNextLevel => xpForLevel(level + 1) - xp;

  // ── Time Energy display aliases (UI rename, data model unchanged) ─────────
  int get timeEnergy => xp;
  String get epochLabel => 'Epoch $level';
  String get chronoRankLabel => rankLabel;

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
    'completedQuizIds': completedQuizIds,
    'lastFactDate': lastFactDate?.toIso8601String(),
    'exploredPlaceIds': exploredPlaceIds,
    'completedEventIds': completedEventIds,
    'answeredQuestionIds': answeredQuestionIds,
    'dailyMission': dailyMission?.toJson(),
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
    completedQuizIds: List<String>.from(json['completedQuizIds'] ?? []),
    lastFactDate: json['lastFactDate'] != null ? DateTime.tryParse(json['lastFactDate']) : null,
    exploredPlaceIds: List<String>.from(json['exploredPlaceIds'] ?? []),
    completedEventIds: List<String>.from(json['completedEventIds'] ?? []),
    answeredQuestionIds: List<String>.from(json['answeredQuestionIds'] ?? []),
    dailyMission: json['dailyMission'] is Map
        ? DailyMission.fromJson(Map<String, dynamic>.from(json['dailyMission']))
        : null,
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
    completedQuizIds,
    lastFactDate,
    exploredPlaceIds,
    completedEventIds,
    answeredQuestionIds,
    dailyMission,
  ];
}
