import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/quiz_topic.dart';
import '../../domain/usecases/get_daily_quiz.dart';
import '../../domain/usecases/submit_answer.dart';
import '../../domain/usecases/calculate_score.dart';

// Prefix used for all high-score SharedPreferences keys.
const String _kHighScorePrefix = 'quiz_high_score_';

abstract class QuizState extends Equatable {
  const QuizState();
  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}
class QuizLoading extends QuizState {}
class QuizLoaded extends QuizState {
  final Quiz quiz;
  final DifficultyLevel? difficulty;
  final int currentQuestionIndex;
  final int score;
  final bool isFinished;
  final int? lastSelectedAction; // For visual feedback
  final bool showingExplanation;

  const QuizLoaded({
    required this.quiz,
    this.difficulty,
    this.currentQuestionIndex = 0,
    this.score = 0,
    this.isFinished = false,
    this.lastSelectedAction,
    this.showingExplanation = false,
  });

  @override
  List<Object?> get props => [quiz, difficulty, currentQuestionIndex, score, isFinished, lastSelectedAction, showingExplanation];

  QuizLoaded copyWith({
    int? currentQuestionIndex,
    int? score,
    bool? isFinished,
    int? lastSelectedAction,
    bool? showingExplanation,
  }) {
    return QuizLoaded(
      quiz: quiz,
      difficulty: difficulty,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      isFinished: isFinished ?? this.isFinished,
      lastSelectedAction: lastSelectedAction ?? this.lastSelectedAction,
      showingExplanation: showingExplanation ?? this.showingExplanation,
    );
  }
}
class QuizError extends QuizState {
  final String message;
  const QuizError(this.message);
  @override
  List<Object?> get props => [message];
}

class QuizCubit extends Cubit<QuizState> {
  final GetDailyQuiz getDailyQuiz;
  final SubmitAnswer submitAnswer;
  final CalculateScore calculateScore;

  QuizCubit({
    required this.getDailyQuiz,
    required this.submitAnswer,
    required this.calculateScore,
  }) : super(QuizInitial());

  Future<void> loadQuiz({String? category, DifficultyLevel? difficulty}) async {
    emit(QuizLoading());
    try {
      final quiz = await getDailyQuiz(category: category, difficulty: difficulty);
      emit(QuizLoaded(quiz: quiz, difficulty: difficulty));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  void answerQuestion(int selectedIndex) {
    if (state is! QuizLoaded) return;
    final currentState = state as QuizLoaded;
    if (currentState.showingExplanation) return; // Prevent double taps
    
    final isCorrect = submitAnswer(
      currentState.quiz.questions[currentState.currentQuestionIndex],
      selectedIndex,
    );

    final newScore = isCorrect ? currentState.score + 1 : currentState.score;
    
    emit(currentState.copyWith(
      score: newScore,
      lastSelectedAction: selectedIndex,
      showingExplanation: true,
    ));
  }

  void nextQuestion() {
    if (state is! QuizLoaded) return;
    final currentState = state as QuizLoaded;

    final nextIndex = currentState.currentQuestionIndex + 1;
    final isFinished = nextIndex >= currentState.quiz.questions.length;

    if (isFinished) {
      final percentage = calculateScore(
        currentState.score,
        currentState.quiz.questions.length,
      );
      _saveHighScore(currentState.quiz.id, percentage);
    }

    emit(currentState.copyWith(
      currentQuestionIndex: isFinished ? currentState.currentQuestionIndex : nextIndex,
      isFinished: isFinished,
      showingExplanation: false,
      lastSelectedAction: null,
    ));
  }

  /// Persists the score only if it beats the stored high score for this category.
  Future<void> _saveHighScore(String quizId, int scorePercent) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_kHighScorePrefix$quizId';
    final stored = prefs.getInt(key) ?? 0;
    if (scorePercent > stored) {
      await prefs.setInt(key, scorePercent);
    }
  }

  /// Returns the stored high score percentage for a category (0 if never played).
  static Future<int> loadHighScore(String quizId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_kHighScorePrefix$quizId') ?? 0;
  }
}
