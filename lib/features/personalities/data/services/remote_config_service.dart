import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeexplorer/core/config/app_config.dart';
import '../repositories/character_firestore_repository.dart';

/// Central Firebase Remote Config service.
///
/// Fetch once per session (or per configured interval). All callers read from
/// the in-memory activated snapshot — no repeated network calls.
class RemoteConfigService {
  static const _prefKey = 'character_prompts_version';

  // ── Remote Config keys ────────────────────────────────────────────────────
  static const _keyCharacterPromptsVersion = 'character_prompts_version';
  static const _keyGeminiModel = 'gemini_model_name';
  static const _keyMaintenanceMode = 'maintenance_mode';
  static const _keyAiRetryLimit = 'ai_retry_limit';
  static const _keyXpMultiplier = 'xp_multiplier';
  static const _keyMaxDailyMessages = 'max_daily_messages';
  static const _keyEnablePersonalityChat = 'enable_personality_chat';
  static const _keyEnableAiInsights = 'enable_ai_insights';
  static const _keyEnableQuiz = 'enable_quiz';

  // ── Safe defaults (used when RC is unavailable) ───────────────────────────
  static const _defaults = {
    _keyCharacterPromptsVersion: '',
    _keyGeminiModel: AppConfig.geminiModel,
    _keyMaintenanceMode: false,
    _keyAiRetryLimit: 2,
    _keyXpMultiplier: 1.0,
    _keyMaxDailyMessages: 100,
    _keyEnablePersonalityChat: true,
    _keyEnableAiInsights: true,
    _keyEnableQuiz: true,
  };

  static FirebaseRemoteConfig get _rc => FirebaseRemoteConfig.instance;

  // ── Typed accessors ───────────────────────────────────────────────────────

  static String get geminiModelName => _rc.getString(_keyGeminiModel).isNotEmpty
      ? _rc.getString(_keyGeminiModel)
      : _defaults[_keyGeminiModel] as String;

  static bool get maintenanceMode => _rc.getBool(_keyMaintenanceMode);

  static int get aiRetryLimit {
    final v = _rc.getInt(_keyAiRetryLimit);
    return v > 0 ? v : _defaults[_keyAiRetryLimit] as int;
  }

  static double get xpMultiplier {
    final v = _rc.getDouble(_keyXpMultiplier);
    return v > 0 ? v : (_defaults[_keyXpMultiplier] as num).toDouble();
  }

  static int get maxDailyMessages {
    final v = _rc.getInt(_keyMaxDailyMessages);
    return v > 0 ? v : _defaults[_keyMaxDailyMessages] as int;
  }

  static bool get personalityChatEnabled => _rc.getBool(_keyEnablePersonalityChat);
  static bool get aiInsightsEnabled => _rc.getBool(_keyEnableAiInsights);
  static bool get quizEnabled => _rc.getBool(_keyEnableQuiz);

  // ── Initialisation ────────────────────────────────────────────────────────

  /// Call once post-frame. Fetches, activates, and optionally invalidates
  /// character cache when the prompt version changes.
  static Future<void> checkForUpdates(CharacterFirestoreRepository repo) async {
    try {
      await _rc.setDefaults(_defaults.map((k, v) => MapEntry(k, v)));
      await _rc.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? const Duration(minutes: 1)
            : const Duration(hours: 6),
      ));
      await _rc.fetchAndActivate();

      final remoteVersion = _rc.getString(_keyCharacterPromptsVersion);
      if (remoteVersion.isEmpty) return;

      final prefs = await SharedPreferences.getInstance();
      final localVersion = prefs.getString(_prefKey) ?? '';

      if (remoteVersion != localVersion) {
        debugPrint('[RemoteConfig] Version changed $localVersion → $remoteVersion. '
            'Refreshing characters.');
        repo.clearCache();
        await repo.getAll();
        await prefs.setString(_prefKey, remoteVersion);
      }

      debugPrint('[RemoteConfig] model=$geminiModelName '
          'maintenance=$maintenanceMode xpMul=$xpMultiplier '
          'chat=$personalityChatEnabled insights=$aiInsightsEnabled');
    } catch (e) {
      debugPrint('[RemoteConfig] checkForUpdates failed (non-fatal): $e');
    }
  }
}
