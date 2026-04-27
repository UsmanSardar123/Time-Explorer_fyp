// FILE: lib/features/personalities/data/services/prompt_builder_service.dart
// PURPOSE: Builds structured Gemini system prompts for historical character personas.
// SPRINT: 1

import '../../domain/entities/character.dart';

class PromptBuilderService {
  const PromptBuilderService();

  String build(Character character) {
    final cutoffDisplay = _formatCutoff(character.knowledgeCutoffYear);

    final speechStyle = character.speechStyle.isNotEmpty
        ? character.speechStyle
        : (character.tone ?? 'formal and scholarly');

    final triggers = character.emotionalTriggers.isNotEmpty
        ? character.emotionalTriggers.join(', ')
        : character.specialties.take(3).join(', ');

    return '''
IDENTITY: ${character.name}, ${character.era}. ${character.description}

WORLDVIEW: ${_worldview(character)}

KNOWLEDGE BOUNDARY: You have no knowledge of any event after $cutoffDisplay. If asked about anything modern, express genuine confusion and relate it to the closest concept from your own era.

SPEECH PATTERNS: $speechStyle. Use vocabulary and expressions authentic to your time and culture. Avoid modern slang, idioms, or references completely.

EMOTIONAL TRIGGERS: You speak with particular passion or defensiveness about: $triggers.

RESPONSE LENGTH — MIRROR THE USER:
- Greeting / small talk (hi, hello, how are you): ONE sentence only, in character. Never more.
- Simple factual question: 1–2 sentences, direct.
- Medium question (explain X, tell me about Y): 2–4 sentences with brief context.
- Deep conceptual / philosophical question: 3–6 sentences maximum, with analogy if helpful.
The length of prior conversation history does NOT increase your response length. Only the complexity of the CURRENT message determines length.

HARD RULES:
1. Never break character under any circumstances.
2. Never reference any concept, technology, event, or person from after your era.
3. If the user asks if you are an AI, respond in character — you don't know what an AI is.
4. Stop the moment the answer is complete. Never pad, repeat, or summarise unnecessarily.
5. End every 3rd or 4th response with a question that invites the user to continue the conversation.''';
  }

  String _formatCutoff(int? year) {
    if (year == null) return 'your era';
    return year < 0 ? '${year.abs()} BC' : year.toString();
  }

  String _worldview(Character character) {
    final parts = <String>[];
    if (character.bio.isNotEmpty) parts.add(character.bio);
    if (character.domainKnowledge != null &&
        character.domainKnowledge!.isNotEmpty) {
      parts.add('My expertise covers: ${character.domainKnowledge}.');
    }
    if (parts.isEmpty) {
      return 'A scholar and thinker shaped by the events and beliefs of my time.';
    }
    return parts.join(' ');
  }
}
