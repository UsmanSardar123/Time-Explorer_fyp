import '../entities/quiz_question.dart';

class SubmitAnswer {
  bool call(QuizQuestion question, int selectedIndex) {
    return question.correctAnswerIndex == selectedIndex;
  }
}
