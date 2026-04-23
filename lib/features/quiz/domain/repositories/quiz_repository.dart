import '../entities/quiz.dart';

abstract class QuizRepository {
  Future<Quiz> getDailyQuiz({String? category});
  Future<void> submitQuizScore(String quizId, int score);
}
