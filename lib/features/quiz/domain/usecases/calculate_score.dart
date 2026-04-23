class CalculateScore {
  int call(int correctAnswers, int totalQuestions) {
    if (totalQuestions == 0) return 0;
    return ((correctAnswers / totalQuestions) * 100).round();
  }
}
