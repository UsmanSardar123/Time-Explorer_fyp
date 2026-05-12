import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Production-safe logger.
///
/// - In debug: prints via debugPrint.
/// - In release: errors are forwarded to Crashlytics; info is suppressed.
/// - Never logs API keys, user PII, or chat content.
class AppLogger {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    if (kReleaseMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      debugPrint('[AppLogger] Crashlytics enabled (release build)');
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      debugPrint('[AppLogger] Crashlytics disabled (debug build)');
    }
  }

  /// Informational message — debug only, suppressed in release.
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? "App"}] $message');
    }
  }

  /// Warning — debug only.
  static void warn(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? "App"}] ⚠️ $message');
    }
  }

  /// Non-fatal error — logged to Crashlytics in release; printed in debug.
  static void error(
    String message, {
    String? tag,
    Object? exception,
    StackTrace? stack,
  }) {
    if (kDebugMode) {
      debugPrint('[${tag ?? "App"}] ❌ $message'
          '${exception != null ? " | $exception" : ""}');
    } else {
      FirebaseCrashlytics.instance
          .recordError(exception ?? message, stack, reason: message, fatal: false)
          .ignore();
    }
  }

  /// Fatal — logged to Crashlytics in both modes (used in Flutter error handler).
  static void fatal(
    Object exception,
    StackTrace stack, {
    String? reason,
  }) {
    if (kDebugMode) {
      debugPrint('[App] 💀 FATAL: $exception');
    }
    FirebaseCrashlytics.instance
        .recordError(exception, stack, reason: reason, fatal: true)
        .ignore();
  }

  /// Set user ID on Crashlytics for session attribution (never log PII).
  static void setUserId(String uid) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.setUserIdentifier(uid).ignore();
    }
  }
}
