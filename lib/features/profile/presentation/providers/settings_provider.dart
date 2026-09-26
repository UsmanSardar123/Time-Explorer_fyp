import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeexplorer/core/cache/hive_cache_manager.dart';
import 'package:timeexplorer/core/services/ambient_audio_service.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _streakAlertsKey = 'streak_alerts_enabled';
  static const String _contentAlertsKey = 'content_alerts_enabled';
  static const String _soundEffectsKey = 'sound_effects_enabled';
  static const String _hapticsKey = 'haptics_enabled';

  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  bool _streakAlertsEnabled = true;
  bool _contentAlertsEnabled = true;
  bool _soundEffectsEnabled = true;
  bool _hapticsEnabled = true;
  bool _ambientAudioEnabled = false;

  ThemeMode get themeMode => _themeMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get streakAlertsEnabled => _streakAlertsEnabled;
  bool get contentAlertsEnabled => _contentAlertsEnabled;
  bool get soundEffectsEnabled => _soundEffectsEnabled;
  bool get hapticsEnabled => _hapticsEnabled;
  bool get ambientAudioEnabled => _ambientAudioEnabled;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  String get themeModeLabel {
    switch (_themeMode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
    }
  }

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);
    if (themeIndex != null && themeIndex >= 0 && themeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[themeIndex];
    }
    _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    _streakAlertsEnabled = prefs.getBool(_streakAlertsKey) ?? true;
    _contentAlertsEnabled = prefs.getBool(_contentAlertsKey) ?? true;
    _soundEffectsEnabled = prefs.getBool(_soundEffectsKey) ?? true;
    _hapticsEnabled = prefs.getBool(_hapticsKey) ?? true;
    _ambientAudioEnabled = AmbientAudioService.instance.enabled;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    triggerHaptic();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _themeMode.index);
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    triggerHaptic();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _themeMode.index);
  }

  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    triggerHaptic();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }

  Future<void> toggleStreakAlerts(bool enabled) async {
    _streakAlertsEnabled = enabled;
    notifyListeners();
    triggerHaptic();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_streakAlertsKey, enabled);
  }

  Future<void> toggleContentAlerts(bool enabled) async {
    _contentAlertsEnabled = enabled;
    notifyListeners();
    triggerHaptic();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_contentAlertsKey, enabled);
  }

  Future<void> toggleSoundEffects(bool enabled) async {
    _soundEffectsEnabled = enabled;
    notifyListeners();
    triggerHaptic();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEffectsKey, enabled);
  }

  Future<void> toggleHaptics(bool enabled) async {
    _hapticsEnabled = enabled;
    notifyListeners();
    if (enabled) {
      HapticFeedback.mediumImpact();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsKey, enabled);
  }

  Future<void> toggleAmbientAudio(bool enabled) async {
    _ambientAudioEnabled = enabled;
    await AmbientAudioService.instance.toggle();
    _ambientAudioEnabled = AmbientAudioService.instance.enabled;
    notifyListeners();
    triggerHaptic();
  }

  void triggerHaptic() {
    if (_hapticsEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  /// Clears cache memory and storage across Hive and Image Cache
  Future<void> clearAppCache() async {
    try {
      await HiveCacheManager.invalidateAll();
      await DefaultCacheManager().emptyCache();
      triggerHaptic();
      notifyListeners();
    } catch (e) {
      debugPrint('[SettingsProvider] Cache clear error: $e');
    }
  }
}
