// FILE: lib/features/places/data/services/local_guide_prompt_builder.dart
// PURPOSE: Builds the strict "Talk to Local" system prompt injected with place-specific context.
// SPRINT: local-guide

import '../../domain/entities/place.dart';

class LocalGuidePromptBuilder {
  static String build(Place place) {
    final era =
        place.historicalPeriod ?? place.eraLabel ?? place.era ?? place.category;

    final contextLines = <String>[
      'Name: ${place.name}',
      'Location: ${place.location}${place.country != null ? ", ${place.country}" : ""}',
      'Era / Period: $era',
      'Description: ${place.description}',
      if (place.history != null) 'Historical background: ${place.history}',
      if (place.civilization != null) 'Civilization: ${place.civilization}',
      if (place.builtBy != null) 'Built by: ${place.builtBy}',
      if (place.constructionDate != null)
        'Construction date: ${place.constructionDate}',
      if (place.architecturalStyle != null)
        'Architectural style: ${place.architecturalStyle}',
      if (place.unescoStatus != null) 'UNESCO status: ${place.unescoStatus}',
      if (place.significance != null || place.historicalSignificance != null)
        'Significance: ${place.significance ?? place.historicalSignificance}',
      if (place.openingHours != null) 'Opening hours: ${place.openingHours}',
      if (place.ticketPrice != null) 'Ticket price: ${place.ticketPrice}',
      if (place.bestTimeToVisit != null)
        'Best time to visit: ${place.bestTimeToVisit}',
      if (place.visitDuration != null)
        'Recommended visit duration: ${place.visitDuration}',
      if (place.dimensions != null) 'Dimensions: ${place.dimensions}',
      if (place.primaryMaterial != null) 'Material: ${place.primaryMaterial}',
      if (place.didYouKnow != null) 'Did you know: ${place.didYouKnow}',
    ];

    final facts = (place.facts ?? place.funFacts ?? []).take(5).toList();
    if (facts.isNotEmpty) {
      contextLines.add('Interesting facts: ${facts.join(" | ")}');
    }

    return '''
You are a location-aware AI assistant embedded in the "Talk to Local" feature of Time Explorer.
You behave as a knowledgeable, concise local guide for the place below.

PLACE CONTEXT:
${contextLines.map((l) => '• $l').join('\n')}

STRICT RESPONSE RULES:
1. Keep answers SHORT by default.
   - Factual questions: maximum 1–2 sentences.
   - Descriptive questions: maximum 3 sentences.
2. Answer DIRECTLY. No introductions. No background padding. No "Great question!".
3. Be PRECISE. Give exact numbers when available.
4. Stay focused on ${place.name} and its historical / practical context.
5. No bullet points unless the user explicitly asks for a list.
6. Tone: natural, confident, helpful. Never robotic or overly enthusiastic.
7. Only expand when the user explicitly asks for more detail.
8. If you don't know something, say so in one sentence.

If the answer can be given in one sentence, always prefer one sentence.
''';
  }
}
