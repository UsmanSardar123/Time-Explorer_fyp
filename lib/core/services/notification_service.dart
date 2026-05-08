import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const String _channelId = 'time_explorer_main';
  static const String _channelName = 'Time Explorer';
  static const String _channelDesc =
      'Timeline discoveries, streaks, and XP updates';

  static const int _idStreakWarning = 1;
  static const int _idStreakBroken = 2;
  static const int _idXPEarned = 3;
  static const int _idLevelUp = 4;
  static const int _idBadge = 5;
  static const int _idNewContent = 6;
  static const int _idInactivity = 7;

  static const String _kLastXPNotifMs = 'notif_last_xp_ms';
  static const int _xpCooldownMinutes = 10;

  static Future<void> init() async {
    if (_initialized) return;
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      await androidImpl.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDesc,
          importance: Importance.high,
          playSound: true,
        ),
      );
      await androidImpl.requestNotificationsPermission();
    }

    _initialized = true;
    debugPrint('[NOTIFICATIONS] Service initialized');
  }

  static AndroidNotificationDetails get _androidDetails =>
      const AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

  static Future<void> _show(int id, String title, String body) async {
    if (!_initialized) return;
    try {
      await _plugin.show(
        id,
        title,
        body,
        NotificationDetails(android: _androidDetails),
      );
      debugPrint('[NOTIFICATIONS] Shown: $title');
    } catch (e) {
      debugPrint('[NOTIFICATIONS] Failed to show: $e');
    }
  }

  // ── Streak notifications ────────────────────────────────────────────────────

  static Future<void> showStreakWarning(int streakDays) => _show(
        _idStreakWarning,
        '⚠️ Your timeline streak ends soon!',
        'Keep your $streakDays-day streak alive — the chronicles await',
      );

  static Future<void> showStreakBroken() => _show(
        _idStreakBroken,
        '⛔ Your timeline streak has been reset',
        'Every great historian begins again — start a new chronicle',
      );

  // ── XP & progression notifications ─────────────────────────────────────────

  static Future<void> showXPEarned(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final lastMs = prefs.getInt(_kLastXPNotifMs) ?? 0;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (nowMs - lastMs < _xpCooldownMinutes * 60 * 1000) return;
    await prefs.setInt(_kLastXPNotifMs, nowMs);
    await _show(
      _idXPEarned,
      '🎉 +$amount XP earned for exploring history!',
      'Your chronicles grow — the timeline expands with your knowledge',
    );
  }

  static Future<void> showLevelUp(int level, String rankLabel) => _show(
        _idLevelUp,
        '⬆️ You reached Level $level: $rankLabel!',
        'The annals of time recognize your mastery — keep exploring',
      );

  static Future<void> showBadgeUnlocked(String badgeName, String icon) =>
      _show(
        _idBadge,
        '$icon Badge unlocked: $badgeName',
        'Your legacy grows — a new chapter in your timeline',
      );

  static Future<void> showLeaderboardRank(int rank) => _show(
        _idXPEarned,
        '🥇 You are now Rank #$rank on the leaderboard!',
        'Your place in the annals of Time Explorers is secured',
      );

  // ── New content notification ────────────────────────────────────────────────

  static Future<void> showNewContent(String title, {String? eraName}) {
    final body = eraName != null
        ? '🌍 New discovery in $eraName — step into the chronicle'
        : '🌍 New historical content awaits your exploration';
    return _show(
      _idNewContent,
      '🆕 $title added to the timeline!',
      body,
    );
  }

  // ── Inactivity reminders ────────────────────────────────────────────────────

  static Future<void> showInactivityReminder(int daysSinceActive) {
    if (daysSinceActive >= 3) {
      return _show(
        _idInactivity,
        '⏳ The chronicles of time call for your return',
        'Three days have passed — history awaits your rediscovery',
      );
    }
    return _show(
      _idInactivity,
      '📜 Your timeline awaits your return',
      'Continue your chronological journey through history',
    );
  }

  // ── Utility ─────────────────────────────────────────────────────────────────

  static Future<void> cancelAll() async {
    if (!_initialized) return;
    await _plugin.cancelAll();
  }
}
