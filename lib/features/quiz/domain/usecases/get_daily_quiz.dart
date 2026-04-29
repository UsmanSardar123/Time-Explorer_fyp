import '../entities/quiz.dart';
import '../entities/quiz_topic.dart';
import '../repositories/quiz_repository.dart';

class GetDailyQuiz {
  final QuizRepository repository;

  GetDailyQuiz(this.repository);

  Future<Quiz> call({String? category, DifficultyLevel? difficulty}) async {
    return await repository.getDailyQuiz(category: category, difficulty: difficulty);
  }
}
