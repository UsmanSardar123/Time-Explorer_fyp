import 'package:shared_preferences/shared_preferences.dart';

class AmbientAudioService {
  AmbientAudioService._();
  static final AmbientAudioService instance = AmbientAudioService._();

  static const _key = 'ambient_audio_enabled';
  bool _enabled = false;

  bool get enabled => _enabled;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(_key) ?? false;
  }

  Future<void> toggle() async {
    _enabled = !_enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, _enabled);
  }
}
