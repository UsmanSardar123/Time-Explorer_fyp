import 'package:flutter/foundation.dart';

/// Centralized app configuration sourced exclusively from --dart-define.
/// Run the app with:
///   flutter run --dart-define=GEMINI_API_KEY=... --dart-define=PIXABAY_API_KEY=...
class AppConfig {
  // Compile-time constants from --dart-define
  static const String _geminiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const String _pixabayKey = String.fromEnvironment(
    'PIXABAY_API_KEY',
    defaultValue: '53527064-edf2dfe298a58b020b583beec',
  );

  // Runtime override (e.g., for testing or dynamic injection)
  static String? _runtimeGeminiKey;

  /// Allows setting the Gemini API key at runtime (e.g., from a secure storage).
  static void setGeminiKey(String key) {
    _runtimeGeminiKey = key;
  }

  /// Centralized Gemini model name.
  static const String geminiModel = 'gemini-3.5-flash';

  static String get geminiApiKey => (_runtimeGeminiKey ?? _geminiKey).trim();
  static String get pixabayApiKey => _pixabayKey.trim();

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
    debugPrint('[AppConfig] Pixabay key length: ${pixabayApiKey.length}');
  }
}
