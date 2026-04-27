// FILE: lib/features/personalities/data/services/remote_config_service.dart
// PURPOSE: Checks Firebase Remote Config version on app start and invalidates character cache when changed.
// SPRINT: 5

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/character_firestore_repository.dart';

class RemoteConfigService {
  static const _prefKey = 'character_prompts_version';
  static const _rcKey = 'character_prompts_version';

  static Future<void> checkForUpdates(
      CharacterFirestoreRepository repo) async {
    try {
      final rc = FirebaseRemoteConfig.instance;
      await rc.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await rc.fetchAndActivate();

      final remoteVersion = rc.getString(_rcKey);
      if (remoteVersion.isEmpty) return;

      final prefs = await SharedPreferences.getInstance();
      final localVersion = prefs.getString(_prefKey) ?? '';

      if (remoteVersion != localVersion) {
        debugPrint(
            '[RemoteConfig] Version changed $localVersion → $remoteVersion. Refreshing characters.');
        repo.clearCache();
        await repo.getAll();
        await prefs.setString(_prefKey, remoteVersion);
      }
    } catch (e) {
      debugPrint('[RemoteConfig] checkForUpdates failed (non-fatal): $e');
    }
  }
}
