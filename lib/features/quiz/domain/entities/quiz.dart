import 'package:equatable/equatable.dart';
import 'quiz_question.dart';

class Quiz extends Equatable {
  final String id;
  final String title;
  final List<QuizQuestion> questions;
  final DateTime date;

  const Quiz({
    required this.id,
    required this.title,
    required this.questions,
    required this.date,
  });

  @override
  List<Object?> get props => [id, title, questions, date];
}
