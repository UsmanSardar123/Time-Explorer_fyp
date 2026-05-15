import 'package:flutter/material.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character_category.dart';
import 'package:timeexplorer/features/personalities/presentation/pages/personality_chat_page.dart';
import '../../domain/entities/event_category.dart';
import '../../domain/entities/historical_event.dart';

/// Bridges a [HistoricalEvent] into the existing [PersonalityChatPage] by
/// synthesising a [Character] that acts as a scholarly expert on that event.
/// No chat infrastructure is duplicated — this class only builds the prompt.
class EventExpertChatPage extends StatelessWidget {
  final HistoricalEvent event;

  const EventExpertChatPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return PersonalityChatPage(
      character: _buildCharacter(),
      initialMessage:
          'Can you give me an expert overview of ${event.title} and why it matters historically?',
    );
  }

  Character _buildCharacter() => Character(
        id: 'expert_${event.id}',
        name: 'History Expert',
        title: 'Specialist in ${event.category.displayName}',
        era: event.period,
        origin: event.location,
        description:
            'A distinguished historian specialising in ${event.title} '
            'and the broader context of ${event.category.displayName}.',
        category: _mapCategory(),
        imageUrl: event.heroImageUrl,
        bio: 'Expert on ${event.title} (${event.period}, ${event.location}).',
        chatPrompt: _buildSystemPrompt(),
        speechStyle: 'scholarly, concise, educational',
        fallbackResponses: const [
          'My historical archives are momentarily unavailable — please ask again in a moment.',
          'The connection to my knowledge base was disrupted. Please retry.',
        ],
        rateLimitWarning:
            'You are approaching the daily question limit for this expert session.',
      );

  CharacterCategory _mapCategory() => switch (event.category) {
        EventCategory.scienceAndDiscoveries => CharacterCategory.scientists,
        EventCategory.cultureAndCivilizations => CharacterCategory.philosophers,
        EventCategory.warsAndConflicts => CharacterCategory.leaders,
        EventCategory.revolutionsAndPolitical => CharacterCategory.leaders,
      };

  String _buildSystemPrompt() => '''
You are a distinguished academic historian and world-leading expert on the following historical event:

EVENT: ${event.title}
PERIOD: ${event.period}
LOCATION: ${event.location}
CATEGORY: ${event.category.displayName}

OVERVIEW:
${event.description}

KEY FACTS:
${event.keyFacts.map((f) => '• $f').join('\n')}

INSTRUCTIONS:
- Respond as a scholarly but approachable historian — no jargon without explanation.
- Keep answers concise (3–5 sentences) unless the user explicitly asks for more detail.
- Every response must connect back to the specific context of ${event.title}.
- If asked about unrelated events, briefly redirect: "As an expert on ${event.title}, I focus our discussion there, but I can note that…"
- Correct misconceptions gently and with evidence.
- Use the key facts and timeline above to ground your answers.
- Educational tone: aim to genuinely inform and engage.
''';
}
