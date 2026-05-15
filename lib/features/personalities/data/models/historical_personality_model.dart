class HistoricalPersonality {
  final String id;
  final String name;
  final String title;
  final String civilization;
  final String era;
  final String period;
  final String category;
  final String styleTag;
  final List<String> keywords;
  final int chronologicalOrder;
  final int? knowledgeCutoffYear;
  final String description;
  final String bio;
  final String origin;
  final String chatPrompt;
  final String domainKnowledge;
  final List<String> specialties;
  final List<String> emotionalTriggers;
  final List<String> fallbackResponses;
  final String rateLimitWarning;
  final String imageUrl;

  const HistoricalPersonality({
    required this.id,
    required this.name,
    required this.title,
    required this.civilization,
    required this.era,
    required this.period,
    required this.category,
    required this.styleTag,
    required this.keywords,
    required this.chronologicalOrder,
    required this.description,
    required this.bio,
    required this.origin,
    required this.chatPrompt,
    this.knowledgeCutoffYear,
    this.domainKnowledge = '',
    this.specialties = const [],
    this.emotionalTriggers = const [],
    this.fallbackResponses = const [],
    this.rateLimitWarning = 'You are approaching the daily question limit.',
    this.imageUrl = '',
  });

  Map<String, dynamic> toFirestoreMap() => {
        'id': id,
        'name': name,
        'title': title,
        'civilizationId': civilization,
        'eraLabel': era,
        'era': period,
        'category': category,
        'origin': origin,
        'description': description,
        'bio': bio,
        'chatPrompt': chatPrompt,
        'speechStyle': styleTag,
        'tone': styleTag,
        'communicationStyle': styleTag,
        'domainKnowledge': domainKnowledge,
        'knowledgeCutoffYear': knowledgeCutoffYear,
        'specialties': specialties,
        'keywords': keywords,
        'emotionalTriggers': emotionalTriggers,
        'fallbackResponses': fallbackResponses,
        'rateLimitWarning': rateLimitWarning,
        'imageUrl': imageUrl,
        'chronologicalOrder': chronologicalOrder,
        'contributions': const [],
        'facts': const [],
        'contextFacts': const {},
        'quiz': const [],
      };
}
