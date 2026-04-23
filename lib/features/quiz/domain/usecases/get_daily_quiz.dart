import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class GetDailyQuiz {
  final QuizRepository repository;

  GetDailyQuiz(this.repository);

  Future<Quiz> call({String? category}) async {
    return await repository.getDailyQuiz(category: category);
  }
}
