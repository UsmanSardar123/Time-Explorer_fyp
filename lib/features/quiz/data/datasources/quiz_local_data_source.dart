import 'package:flutter/foundation.dart';
import '../../domain/entities/quiz.dart';
import 'static_quiz_data.dart';
import 'quiz_questions_pool.dart';

abstract class QuizLocalDataSource {
  Future<Quiz> getDailyQuiz({String? category});
  Future<void> saveQuizScore(String quizId, int score);
}

class QuizLocalDataSourceImpl implements QuizLocalDataSource {
  @override
  Future<Quiz> getDailyQuiz({String? category}) async {
    // Simulating network/local delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (category != null && quizPool.containsKey(category)) {
      final pool = quizPool[category]!;
      // Shuffle and take 10
      final questions = List.of(pool)..shuffle();
      return Quiz(
        id: 'quiz_${category.toLowerCase().replaceAll(' ', '_')}',
        title: '$category Quiz',
        date: DateTime.now(),
        questions: questions.take(10).toList(),
      );
    }

    // Default fallback
    return dummyDailyQuiz;
  }

  @override
  Future<void> saveQuizScore(String quizId, int score) async {
    debugPrint('Saving score $score for quiz $quizId');
  }
}
