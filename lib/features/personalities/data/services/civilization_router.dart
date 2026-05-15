import '../models/historical_personality_model.dart';

enum ChatRoutingMode { eraFlow, legend, hybrid }

class CivilizationRouter {
  // ── Era Flow: per-civilization cursor ─────────────────────────────────────
  static final Map<String, int> _cursors = {};

  /// Returns the next personality in chronological order, cycling on wrap-around.
  static HistoricalPersonality nextInFlow(
    String civilizationId,
    List<HistoricalPersonality> personalities,
  ) {
    final sorted = _chronological(personalities);
    final cursor = _cursors[civilizationId] ?? 0;
    final next = sorted[cursor % sorted.length];
    _cursors[civilizationId] = (cursor + 1) % sorted.length;
    return next;
  }

  /// Returns the best-matching personality for [query] via keyword scoring.
  static HistoricalPersonality matchByQuery(
    String query,
    List<HistoricalPersonality> personalities,
  ) {
    final words = _tokenise(query);
    int highScore = 0;
    HistoricalPersonality? best;

    for (final p in personalities) {
      final score = _score(p, words);
      if (score > highScore) {
        highScore = score;
        best = p;
      }
    }
    return best ?? _chronological(personalities).first;
  }

  /// Main entry point. Hybrid mode auto-detects open-ended vs specific queries.
  static HistoricalPersonality route(
    String query,
    List<HistoricalPersonality> personalities, {
    ChatRoutingMode mode = ChatRoutingMode.hybrid,
    String? civilizationId,
  }) =>
      switch (mode) {
        ChatRoutingMode.eraFlow =>
          nextInFlow(civilizationId ?? '_default', personalities),
        ChatRoutingMode.legend => matchByQuery(query, personalities),
        ChatRoutingMode.hybrid =>
          _hybrid(query, personalities, civilizationId),
      };

  // ── Fallback chain ─────────────────────────────────────────────────────────

  /// Returns the default personality — first in chronological order.
  static HistoricalPersonality defaultFor(
          List<HistoricalPersonality> personalities) =>
      _chronological(personalities).first;

  /// Returns personalities for a given era label.
  static List<HistoricalPersonality> filterByEra(
    String eraLabel,
    List<HistoricalPersonality> personalities,
  ) =>
      personalities.where((p) => p.era == eraLabel).toList();

  // ── Cursor management ──────────────────────────────────────────────────────

  static void resetCursor(String civilizationId) =>
      _cursors.remove(civilizationId);

  static void resetAllCursors() => _cursors.clear();

  static int cursorFor(String civilizationId) => _cursors[civilizationId] ?? 0;

  // ── Private helpers ────────────────────────────────────────────────────────

  static HistoricalPersonality _hybrid(
    String query,
    List<HistoricalPersonality> personalities,
    String? civilizationId,
  ) {
    const openEndedPattern =
        r'\b(next|continue|who else|what.?s next|tell me more|show me)\b';
    final isOpenEnded =
        RegExp(openEndedPattern, caseSensitive: false).hasMatch(query);
    return isOpenEnded
        ? nextInFlow(civilizationId ?? '_default', personalities)
        : matchByQuery(query, personalities);
  }

  static int _score(HistoricalPersonality p, List<String> words) {
    final haystack = [
      ...p.keywords,
      ...p.specialties,
      p.name.toLowerCase(),
      p.era.toLowerCase(),
      p.styleTag.toLowerCase(),
      p.title.toLowerCase(),
    ].join(' ');
    return words.fold(0, (s, w) => s + (haystack.contains(w) ? 1 : 0));
  }

  static List<String> _tokenise(String query) =>
      query.toLowerCase().split(RegExp(r'\W+')).where((w) => w.length > 2).toList();

  static List<HistoricalPersonality> _chronological(
          List<HistoricalPersonality> ps) =>
      [...ps]..sort((a, b) => a.chronologicalOrder.compareTo(b.chronologicalOrder));
}
