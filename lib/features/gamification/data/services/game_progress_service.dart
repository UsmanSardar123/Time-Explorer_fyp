import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/game_progress.dart';

const _kTotalXP      = 'gam_total_xp';
const _kStreak       = 'gam_streak';
const _kLastActivity = 'gam_last_activity'; // stored as ISO-8601 date (yyyy-MM-dd)

const _kXPByActivity = {
  ActivityType.quiz:           100,
  ActivityType.placeDiscovery: 50,
};

class GameProgressService {
  // ── Public API ─────────────────────────────────────────────────────────────

  Future<GameProgress> load() async {
    final prefs   = await SharedPreferences.getInstance();
    final totalXP = prefs.getInt(_kTotalXP) ?? 0;
    final streak  = prefs.getInt(_kStreak)  ?? 0;
    return GameProgress.fromXPAndStreak(totalXP, streak);
  }

  /// Called once on cold app open. Updates streak without awarding XP.
  /// Same-day re-opens are no-ops; a gap resets streak to 1.
  Future<GameProgress> recordAppOpen() async {
    final prefs    = await SharedPreferences.getInstance();
    final totalXP  = prefs.getInt(_kTotalXP) ?? 0;
    final streak   = prefs.getInt(_kStreak)  ?? 0;
    final lastRaw  = prefs.getString(_kLastActivity);
    final lastDate = lastRaw != null ? DateTime.tryParse(lastRaw) : null;

    final newStreak = calculateNewStreak(
      currentStreak: streak,
      lastActivityDate: lastDate,
    );

    if (newStreak != streak || lastDate == null) {
      await prefs.setInt(_kStreak, newStreak);
      await prefs.setString(_kLastActivity, _dateOnly(DateTime.now()));
    }

    return GameProgress.fromXPAndStreak(totalXP, newStreak);
  }

  Future<GameProgress> processActivity(ActivityType type) async {
    final prefs      = await SharedPreferences.getInstance();
    final totalXP    = prefs.getInt(_kTotalXP) ?? 0;
    final streak     = prefs.getInt(_kStreak)  ?? 0;
    final lastRaw    = prefs.getString(_kLastActivity);
    final lastDate   = lastRaw != null ? DateTime.tryParse(lastRaw) : null;

    final newXP      = totalXP + (_kXPByActivity[type] ?? 0);
    final newStreak  = calculateNewStreak(
      currentStreak:    streak,
      lastActivityDate: lastDate,
    );

    await prefs.setInt(_kTotalXP, newXP);
    await prefs.setInt(_kStreak,  newStreak);
    await prefs.setString(
      _kLastActivity,
      _dateOnly(DateTime.now()),
    );

    return GameProgress.fromXPAndStreak(newXP, newStreak);
  }

  // ── Pure helpers (static so tests can call without SharedPreferences) ───────

  /// Level = floor(sqrt(totalXP / 100))
  static int calculateLevel(int totalXP) =>
      GameProgress.levelFor(totalXP);

  /// Streak rules:
  ///   diff == 0 → same day, maintain
  ///   diff == 1 → consecutive, increment
  ///   diff  > 1 → gap, reset to 1
  static int calculateNewStreak({
    required int currentStreak,
    required DateTime? lastActivityDate,
    DateTime? now,
  }) {
    now ??= DateTime.now();
    if (lastActivityDate == null) return 1;

    final today    = _dateOnlyDt(now);
    final lastDay  = _dateOnlyDt(lastActivityDate);
    final diffDays = today.difference(lastDay).inDays;

    if (diffDays == 0) return currentStreak;
    if (diffDays == 1) return currentStreak + 1;
    return 1;
  }

  static String   _dateOnly(DateTime dt)     => '${dt.year}-${dt.month.toString().padLeft(2,'0')}-${dt.day.toString().padLeft(2,'0')}';
  static DateTime _dateOnlyDt(DateTime dt)   => DateTime(dt.year, dt.month, dt.day);
}
