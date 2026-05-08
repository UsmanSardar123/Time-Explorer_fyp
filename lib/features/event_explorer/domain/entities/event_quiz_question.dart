import 'package:equatable/equatable.dart';

class EventQuizQuestion extends Equatable {
  final String id;
  final String eventId;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  const EventQuizQuestion({
    required this.id,
    required this.eventId,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  bool isCorrect(int chosenIndex) => chosenIndex == correctIndex;

  @override
  List<Object?> get props => [id, eventId, question, options, correctIndex];
}
