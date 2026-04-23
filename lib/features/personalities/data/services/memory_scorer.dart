import '../../domain/entities/character.dart';

class ChatTurn {
  final Map<String, String> user;
  final Map<String, String> assistant;
  final int index;

  ChatTurn({
    required this.user,
    required this.assistant,
    required this.index,
  });

  double score(Character character, int totalTurns) {
    double score = 0.0;

    // 1. Recency Weight (50% of base)
    // Later turns get higher base score
    score += (index / totalTurns) * 50.0;

    // 2. Anchor Preservation (The absolute first message)
    if (index == 0) {
      score += 1000.0; // Virtually un-deletable if it's the anchor
    }

    // 3. Complexity / Intellectual Density (30%)
    final userContent = user['content'] ?? '';
    final aiContent = assistant['content'] ?? '';
    
    if (userContent.length > 60 || aiContent.length > 150) {
      score += 15.0; // Length often implies depth
    }

    final intellectualKeywords = [
      'explain', 'why', 'how', 'theory', 'reason', 'meaning', 'concept', 
      'history', 'strategy', 'philosophy', 'physics', 'science'
    ];
    
    for (var word in intellectualKeywords) {
      if (userContent.toLowerCase().contains(word)) {
        score += 5.0;
      }
    }

    // 4. Domain Alignment (20%)
    if (character.domainKnowledge != null) {
      final domains = character.domainKnowledge!.toLowerCase().split(',');
      for (var domain in domains) {
        final d = domain.trim();
        if (d.length > 3 && (userContent.toLowerCase().contains(d) || aiContent.toLowerCase().contains(d))) {
          score += 10.0;
        }
      }
    }

    // 5. Casual Penalty
    if (userContent.length < 15 && (userContent.toLowerCase().contains('hi') || userContent.toLowerCase().contains('hello') || userContent.toLowerCase().contains('ok'))) {
      score -= 10.0;
    }

    return score;
  }
}

class MemoryScorer {
  /// Converts a flat history list into a list of [ChatTurn] pairs.
  /// Expects history list [user, assistant, user, assistant, ...]
  static List<ChatTurn> toTurns(List<Map<String, String>> history) {
    final turns = <ChatTurn>[];
    for (int i = 0; i < history.length - 1; i += 2) {
      if (history[i]['role'] == 'user' && history[i + 1]['role'] == 'assistant') {
        turns.add(ChatTurn(
          user: history[i],
          assistant: history[i + 1],
          index: turns.length,
        ));
      }
    }
    return turns;
  }

  /// flattens turns back into a history list
  static List<Map<String, String>> fromTurns(List<ChatTurn> turns) {
    return turns.expand((t) => [t.user, t.assistant]).toList();
  }
}
