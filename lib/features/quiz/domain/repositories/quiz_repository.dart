import '../entities/quiz.dart';
import '../entities/quiz_topic.dart';

abstract class QuizRepository {
  Future<Quiz> getDailyQuiz({String? category, DifficultyLevel? difficulty});
  Future<void> submitQuizScore(String quizId, int score);
}
