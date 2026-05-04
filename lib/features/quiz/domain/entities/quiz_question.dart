import 'package:equatable/equatable.dart';
import 'quiz_topic.dart';

enum QuestionType {
  mcq,
  trueFalse,
  imageBased,
  causeAndEffect,
}

class QuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final QuestionType type;
  final DifficultyLevel difficulty;
  final String? imageUrl;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.type,
    required this.difficulty,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, question, options, correctAnswerIndex, explanation, type, difficulty, imageUrl];
}
