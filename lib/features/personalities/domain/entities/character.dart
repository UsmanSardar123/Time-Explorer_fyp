import 'package:equatable/equatable.dart';
import 'character_category.dart';

class QuizQuestion extends Equatable {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  @override
  List<Object?> get props => [question, options, correctIndex, explanation];
}

class Character extends Equatable {
  final String id;
  final String name;
  final CharacterCategory category;
  final String imageUrl;
  final String title;
  final String dob;
  final String dod;
  final String description;
  final List<String> contributions;
  final List<String> facts;
  final Map<String, String> contextFacts;

  // Metadata for Identity/Roleplay
  final String? tone;
  final String? communicationStyle;
  final String? domainKnowledge;
  final String chatPrompt;

  // Intelligence & Quiz
  final String bio;
  final String era;
  final String origin;
  final List<String> specialties;
  final List<QuizQuestion> quiz;

  // Additional Admin fields (merged)
  final String? nationality;
  final List<String>? achievements;
  final String? legacy;

  // Persona Engine fields (Sprint 1)
  final int? knowledgeCutoffYear;
  final String speechStyle;
  final List<String> emotionalTriggers;
  final List<String> fallbackResponses;
  final String rateLimitWarning;

  const Character({
    required this.id,
    required this.name,
    required this.category,
    required this.era,
    required this.description,
    required this.origin,
    this.imageUrl = '',
    this.title = '',
    this.dob = '',
    this.dod = '',
    this.bio = '',
    this.chatPrompt = '',
    this.contributions = const [],
    this.facts = const [],
    this.contextFacts = const {},
    this.specialties = const [],
    this.quiz = const [],
    this.tone,
    this.communicationStyle,
    this.domainKnowledge,
    this.nationality,
    this.achievements,
    this.legacy,
    this.knowledgeCutoffYear,
    this.speechStyle = '',
    this.emotionalTriggers = const [],
    this.fallbackResponses = const [],
    this.rateLimitWarning = '',
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        tone,
        communicationStyle,
        domainKnowledge,
        bio,
        era,
        origin,
        specialties,
        quiz,
        contextFacts,
        nationality,
        achievements,
        legacy,
        knowledgeCutoffYear,
        speechStyle,
        emotionalTriggers,
        fallbackResponses,
        rateLimitWarning,
      ];
}
