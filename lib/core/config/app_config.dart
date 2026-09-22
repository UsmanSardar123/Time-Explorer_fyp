import 'package:flutter/foundation.dart';

/// Centralized app configuration sourced exclusively from --dart-define.
/// Run the app with:
///   flutter run --dart-define=GEMINI_API_KEY=... --dart-define=PIXABAY_API_KEY=...
class AppConfig {
  // Compile-time constants from --dart-define
  static const String _geminiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AIzaSyDD7JUpwBHX9TuVWDMpWasQMjoXQre2oUk',
  );
  static const String _pixabayKey = String.fromEnvironment(
    'PIXABAY_API_KEY',
    defaultValue: '',
  );

  // Runtime override (e.g., for testing or dynamic injection)
  static String? _runtimeGeminiKey;

  /// Allows setting the Gemini API key at runtime (e.g., from a secure storage).
  static void setGeminiKey(String key) {
    _runtimeGeminiKey = key;
  }

  /// Centralized Gemini model name.
  static const String geminiModel = 'gemini-2.5-flash';

  static String get geminiApiKey => (_runtimeGeminiKey ?? _geminiKey).trim();
  static String get pixabayApiKey => _pixabayKey.trim();

  // Android emulator reaches the host machine through 10.0.2.2.
  // Override via --dart-define=BACKEND_URL=... for a deployed or physical-device backend.
  static const String _configuredBackendUrl = String.fromEnvironment('BACKEND_URL');
  static String get backendBaseUrl {
    if (_configuredBackendUrl.isNotEmpty) return _configuredBackendUrl;
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return 'http://localhost:5000/api';
    }
    return 'http://10.0.2.2:5000/api';
  }

  /// True when Gemini API key is present. Use this to gate all AI features.
  static bool get isAiEnabled => geminiApiKey.isNotEmpty;

  /// Called once at app start. Logs key status without exposing values.
  static void validate() {
    if (isAiEnabled) {
      debugPrint('[AppConfig] ✅ GEMINI_API_KEY present (${geminiApiKey.length} chars)');
    } else {
      debugPrint('[AppConfig] ⚠️  GEMINI_API_KEY missing — AI features disabled. '
          'Provide via --dart-define=GEMINI_API_KEY=<key> or set at runtime via AppConfig.setGeminiKey().');
    }
    debugPrint('[Pixabay] API key loaded: ${pixabayApiKey.isNotEmpty}');
  }
}
