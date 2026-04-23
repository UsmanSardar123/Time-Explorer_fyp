import 'dart:math';

enum ActivityType { quiz, placeDiscovery }

enum Rank { nomad, chronosExplorer, masterOfAges }

class GameProgress {
  final int totalXP;
  final int level;
  final Rank rank;
  final int streak;
  final double xpProgress;   // 0.0–1.0 within current level band
  final int xpToNextLevel;

  const GameProgress({
    required this.totalXP,
    required this.level,
    required this.rank,
    required this.streak,
    required this.xpProgress,
    required this.xpToNextLevel,
  });

  String get rankLabel => switch (rank) {
        Rank.nomad           => 'Nomad',
        Rank.chronosExplorer => 'Chronos-Explorer',
        Rank.masterOfAges    => 'Master-of-Ages',
      };

  factory GameProgress.fromXPAndStreak(int totalXP, int streak) {
    final level          = GameProgress.levelFor(totalXP);
    final bandStart      = _threshold(level);
    final bandEnd        = _threshold(level + 1);
    final xpProgress     = (totalXP - bandStart) / (bandEnd - bandStart);
    final xpToNextLevel  = bandEnd - totalXP;

    final rank = switch (level) {
      <= 5  => Rank.nomad,
      <= 15 => Rank.chronosExplorer,
      _     => Rank.masterOfAges,
    };

    return GameProgress(
      totalXP: totalXP,
      level: level,
      rank: rank,
      streak: streak,
      xpProgress: xpProgress.clamp(0.0, 1.0),
      xpToNextLevel: xpToNextLevel,
    );
  }

  // XP needed to reach a given level.
  static int _threshold(int level) => level * level * 100;

  // Level = floor(sqrt(totalXP / 100))
  static int levelFor(int totalXP) =>
      sqrt(totalXP / 100).floor();

  static GameProgress get zero =>
      GameProgress.fromXPAndStreak(0, 0);
}
