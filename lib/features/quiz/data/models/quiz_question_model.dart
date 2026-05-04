import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/quiz_topic.dart';

class QuizQuestionModel extends QuizQuestion {
  const QuizQuestionModel({
    required super.id,
    required super.question,
    required super.options,
    required super.correctAnswerIndex,
    required super.explanation,
    required super.type,
    required super.difficulty,
    super.imageUrl,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      explanation: json['explanation'],
      type: QuestionType.values.byName(json['type']),
      difficulty: DifficultyLevel.values.byName(json['difficulty']),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'type': type.name,
      'difficulty': difficulty.name,
      'imageUrl': imageUrl,
    };
  }
}
