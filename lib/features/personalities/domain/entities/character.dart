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

  // Metadata for Identity/Roleplay (Sprint 2)
  final String? tone;
  final String? communicationStyle;
  final String? domainKnowledge;
  final String chatPrompt;

  // Intelligence & Quiz (Sprint 6 additions)
  final String bio;
  final String era;
  final String origin;
  final List<String> specialties;
  final List<QuizQuestion> quiz;

  const Character({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.title,
    required this.dob,
    required this.dod,
    required this.description,
    required this.contributions,
    required this.facts,
    required this.chatPrompt,
    required this.bio,
    required this.era,
    required this.origin,
    required this.specialties,
    required this.quiz,
    this.tone,
    this.communicationStyle,
    this.domainKnowledge,
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
      ];
}
