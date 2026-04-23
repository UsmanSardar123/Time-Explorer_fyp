import 'package:equatable/equatable.dart';

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
  final String? imageUrl;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.type,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, question, options, correctAnswerIndex, explanation, type, imageUrl];
}
