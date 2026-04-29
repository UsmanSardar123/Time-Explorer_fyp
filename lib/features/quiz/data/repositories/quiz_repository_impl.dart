import '../../domain/entities/quiz.dart';
import '../../domain/entities/quiz_topic.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_local_data_source.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizLocalDataSource localDataSource;

  QuizRepositoryImpl({required this.localDataSource});

  @override
  Future<Quiz> getDailyQuiz({String? category, DifficultyLevel? difficulty}) async {
    return await localDataSource.getDailyQuiz(category: category, difficulty: difficulty);
  }

  @override
  Future<void> submitQuizScore(String quizId, int score) async {
    return await localDataSource.saveQuizScore(quizId, score);
  }
}
