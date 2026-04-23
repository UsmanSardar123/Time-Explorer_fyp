import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized configuration for environment variables and API keys.
/// Prioritizes --dart-define values over .env file values.
class AppConfig {
  // --- GEMINI API ---
  static const String _geminiEnvKey = 'GEMINI_API_KEY';
  
  /// Reads GEMINI_API_KEY from --dart-define.
  /// Must be a 'static const' to be evaluated at compile time.
  static const String _geminiFromDefine = String.fromEnvironment(
    _geminiEnvKey,
    defaultValue: '',
  );

  /// Returns the active Gemini API Key.
  /// Prioritizes --dart-define, then falls back to .env if loaded.
  static String get geminiApiKey {
    if (_geminiFromDefine.isNotEmpty) {
      return _geminiFromDefine.trim();
    }
    
    if (dotenv.isInitialized) {
      return dotenv.env[_geminiEnvKey]?.trim() ?? '';
    }
    
    return '';
  }

  /// Validation helper to check if critical keys are present.
  static void validate() {
    if (geminiApiKey.isEmpty) {
      debugPrint('[AppConfig] ⚠️  MISSING: $_geminiEnvKey. '
          'Provide via --dart-define=$_geminiEnvKey=<key> or in .env file.');
    } else {
      debugPrint('[AppConfig] ✅ DETECTED: $_geminiEnvKey '
          '(${geminiApiKey.length} characters)');
    }
  }

  // --- PIXABAY API ---
  // Note: Pixabay currently uses a hardcoded key in PixabayService.
  // In the future, it can be moved here.
}
