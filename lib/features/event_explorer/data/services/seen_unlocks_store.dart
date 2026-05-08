import 'package:shared_preferences/shared_preferences.dart';

class SeenUnlocksStore {
  static const String _key = 'seen_unlocked_event_ids';

  Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? const []).toSet();
  }

  Future<void> markSeen(String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? <String>[];
    if (list.contains(eventId)) return;
    list.add(eventId);
    await prefs.setStringList(_key, list);
  }
}
