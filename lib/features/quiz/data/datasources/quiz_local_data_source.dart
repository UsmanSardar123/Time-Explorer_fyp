import 'package:flutter/foundation.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/quiz_topic.dart';
import 'static_quiz_data.dart';
import 'quiz_questions_pool.dart';

abstract class QuizLocalDataSource {
  Future<Quiz> getDailyQuiz({String? category, DifficultyLevel? difficulty});
  Future<void> saveQuizScore(String quizId, int score);
}

class QuizLocalDataSourceImpl implements QuizLocalDataSource {
  @override
  Future<Quiz> getDailyQuiz({String? category, DifficultyLevel? difficulty}) async {
    // Simulating network/local delay
    await Future.delayed(const Duration(milliseconds: 800));

    final targetDifficulty = difficulty ?? DifficultyLevel.easy;
    List<QuizQuestion> pool;

    if (category != null && quizPool.containsKey(category)) {
      pool = quizPool[category]!;
    } else {
      pool = quizPool.values.expand((list) => list).toList();
    }

    final filtered = pool.where((q) => q.difficulty == targetDifficulty).toList();

    if (filtered.isEmpty) {
      // Fallback if no questions found for this difficulty
      return dummyDailyQuiz;
    }

    final questions = List<QuizQuestion>.from(filtered)..shuffle();
    final selectedQuestions = questions.take(10).toList();

    return Quiz(
      id: category != null 
          ? 'quiz_${category.toLowerCase().replaceAll(' ', '_')}_${targetDifficulty.name}'
          : 'daily_${DateTime.now().millisecondsSinceEpoch}_${targetDifficulty.name}',
      title: category != null ? '$category Quiz' : 'Daily Challenge',
      date: DateTime.now(),
      questions: selectedQuestions,
    );
  }

  @override
  Future<void> saveQuizScore(String quizId, int score) async {
    debugPrint('Saving score $score for quiz $quizId');
  }
}
