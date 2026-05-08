import '../entities/event_category.dart';
import '../entities/historical_event.dart';
import '../../../gamification/domain/entities/user_progress.dart';

class EventUnlockService {
  static List<HistoricalEvent> _categoryOrder(
    List<HistoricalEvent> all,
    EventCategory category,
  ) {
    final list = all.where((e) => e.category == category).toList();
    list.sort((a, b) => a.id.compareTo(b.id));
    return list;
  }

  static int _categoryIndex(HistoricalEvent event, List<HistoricalEvent> all) {
    final order = _categoryOrder(all, event.category);
    return order.indexWhere((e) => e.id == event.id);
  }

  static int _importanceLevel(HistoricalEvent event) {
    if (event.importanceLevel >= 5) return 5;
    if (event.importanceLevel >= 4) return 3;
    return 0;
  }

  /// Minimum user level that unlocks [event] regardless of prior completion.
  /// Combines a sequential floor (one level per category index) with the
  /// importance gate so high-impact events always require the same level.
  static int xpThreshold(HistoricalEvent event, List<HistoricalEvent> all) {
    final idx = _categoryIndex(event, all);
    final sequential = idx <= 0 ? 1 : idx + 1;
    final importance = _importanceLevel(event);
    return sequential > importance ? sequential : importance;
  }

  static bool isUnlocked({
    required HistoricalEvent event,
    required List<HistoricalEvent> allEvents,
    required UserProgress progress,
  }) {
    final order = _categoryOrder(allEvents, event.category);
    final idx = order.indexWhere((e) => e.id == event.id);
    if (idx <= 0) return true;

    final previous = order[idx - 1];
    if (progress.completedEventIds.contains(previous.id)) return true;

    return progress.level >= xpThreshold(event, allEvents);
  }

  static String unlockHint({
    required HistoricalEvent event,
    required List<HistoricalEvent> allEvents,
  }) {
    final order = _categoryOrder(allEvents, event.category);
    final idx = order.indexWhere((e) => e.id == event.id);
    if (idx <= 0) return '';
    final previous = order[idx - 1];
    final lvl = xpThreshold(event, allEvents);
    return 'Finish "${previous.title}" or reach Epoch $lvl to unlock.';
  }
}
