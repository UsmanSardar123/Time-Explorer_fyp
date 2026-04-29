import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/services/gamification_service.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/quiz/presentation/cubit/quiz_cubit.dart';
import '../../domain/usecases/get_daily_quiz.dart';
import '../../domain/usecases/submit_answer.dart';
import '../../domain/usecases/calculate_score.dart';
import '../../domain/entities/quiz_topic.dart';
import '../../data/repositories/quiz_repository_impl.dart';
import '../../data/datasources/quiz_local_data_source.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';

class QuizPage extends StatelessWidget {
  final String? category;
  final DifficultyLevel? difficulty;
  const QuizPage({super.key, this.category, this.difficulty});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizCubit(
        getDailyQuiz: GetDailyQuiz(
          QuizRepositoryImpl(localDataSource: QuizLocalDataSourceImpl()),
        ),
        submitAnswer: SubmitAnswer(),
        calculateScore: CalculateScore(),
      )..loadQuiz(category: category, difficulty: difficulty),
      child: const QuizView(),
    );
  }
}

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: BlocConsumer<QuizCubit, QuizState>(
        // Fire when an answer is submitted (showingExplanation flips to true).
        listenWhen: (prev, curr) {
          if (curr is! QuizLoaded || prev is! QuizLoaded) return false;
          return !prev.showingExplanation && curr.showingExplanation;
        },
        listener: (context, state) {
          if (state is! QuizLoaded) return;
          final q = state.quiz.questions[state.currentQuestionIndex];
          final isCorrect = q.correctAnswerIndex == state.lastSelectedAction;
          final gam = context.read<GamificationProvider>();
          if (isCorrect) {
            gam.recordCorrectAnswer();
          } else {
            gam.recordWrongAnswer();
          }
        },
        builder: (context, state) {
          if (state is QuizLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryContainer));
          }
          if (state is QuizError) {
            return Center(child: Text(state.message));
          }
          if (state is QuizLoaded) {
            if (state.isFinished) {
              return _buildResultView(state);
            }
            return _buildQuizContent(state);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildQuizContent(QuizLoaded state) {
    if (state.quiz.questions.isEmpty) {
      return const Center(child: Text('No questions available for this quiz.'));
    }
    final question = state.quiz.questions[state.currentQuestionIndex];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 1. Top HUD
            _buildHUD(state),
            
            const SizedBox(height: 40),
            
            // 2. Question card
            _buildQuestionCard(question.question),
            
            const SizedBox(height: 32),
            
            // 3. Answer cards
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _AnswerCard(
                      label: question.options[index],
                      isSelected: state.lastSelectedAction == index,
                      isCorrect: question.correctAnswerIndex == index,
                      isReviewing: state.showingExplanation,
                      onTap: () => context.read<QuizCubit>().answerQuestion(index),
                    ),
                  );
                },
              ),
            ),
            
            // Explanation footer
            if (state.showingExplanation) ...[
              _buildExplanationFooter(question.explanation),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHUD(QuizLoaded state) {
    final total = state.quiz.questions.length;
    final progress = total > 0 ? (state.currentQuestionIndex + 1) / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.difficulty != null)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              state.difficulty!.label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryContainer,
              ),
            ),
          ),
        Row(
      children: [
        // Left: Hearts
        const Row(
          children: [
            Icon(Icons.favorite_rounded, color: AppTheme.primaryContainer, size: 20),
            Icon(Icons.favorite_rounded, color: AppTheme.primaryContainer, size: 20),
            Icon(Icons.favorite_border_rounded, color: AppTheme.primaryContainer, size: 20),
          ],
        ),
        const SizedBox(width: 16),
        // Center: Progress bar
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: AppTheme.outlineVariant,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 10,
                width: MediaQuery.of(context).size.width * 0.4 * progress,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Right: Timer circle
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppTheme.surfaceLow,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '15',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryContainer,
              ),
            ),
          ),
        ),
      ],
        ),
      ],
    );
  }

  Widget _buildQuestionCard(String question) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: Text(
          question,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildExplanationFooter(String explanation) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryContainer.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Text(
            explanation,
            style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppTheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.read<QuizCubit>().nextQuestion(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Next Question', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView(QuizLoaded state) {
    return _ResultView(
      quizId: state.quiz.id,
      score: state.score,
      total: state.quiz.questions.length,
    );
  }
}

class _ResultView extends StatefulWidget {
  final String quizId;
  final int score;
  final int total;
  const _ResultView({required this.quizId, required this.score, required this.total});

  @override
  State<_ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<_ResultView>
    with SingleTickerProviderStateMixin {
  static const _primary = AppTheme.primaryContainer;
  static const _accentAmber = AppTheme.amber;

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  late final Animation<double> _scale = Tween<double>(begin: 0.65, end: 1.0)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
  late final Animation<double> _fade = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));

  bool get _isHighScore => widget.total > 0 && widget.score / widget.total >= 0.8;

  // Accurate XP this session: per-answer XP + session bonus.
  // First-time completion bonus (+20) is excluded here (awarded separately, silently).
  int get _xpEarned {
    final wrong = widget.total - widget.score;
    return (widget.score * GamificationService.xpCorrectAnswer) +
        (wrong * GamificationService.xpWrongAnswer) +
        GamificationService.xpQuizSessionBonus;
  }

  String get _grade {
    if (widget.total == 0) return '—';
    final pct = widget.score / widget.total;
    if (pct >= 0.9) return '🔥 Legendary!';
    if (pct >= 0.7) return '⭐ Great Job!';
    if (pct >= 0.5) return '👍 Good Effort!';
    return '💪 Keep Exploring!';
  }

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
    // Award first-time completion bonus (+20 XP, idempotent) and session bonus (+30 XP).
    Future.microtask(() {
      if (!mounted) return;
      final gam = context.read<GamificationProvider>();
      gam.recordQuizCompleted(widget.quizId);
      gam.recordQuizSessionComplete();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutBack,
                  builder: (_, v, child) => Transform.scale(scale: v, child: child),
                  child: Icon(
                    _isHighScore ? Icons.stars_rounded : Icons.emoji_events_rounded,
                    size: 90,
                    color: _isHighScore ? _accentAmber : _primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(_grade,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: _isHighScore ? _accentAmber : _primary,
                    )),
                const SizedBox(height: 8),
                Text('Adventure Completed!',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26, fontWeight: FontWeight.w800,
                      color: AppTheme.onSurface,
                    )),
                const SizedBox(height: 32),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: _isHighScore
                        ? [BoxShadow(
                            color: _accentAmber.withValues(alpha: 0.3),
                            blurRadius: 28, spreadRadius: 2,
                          )]
                        : [BoxShadow(
                            color: const Color(0x0A1E1B17),
                            blurRadius: 16, offset: const Offset(0, 8),
                          )],
                  ),
                  child: Column(
                    children: [
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: 0, end: widget.score),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOut,
                        builder: (_, val, child) => Text('$val / ${widget.total}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 52, fontWeight: FontWeight.w900, color: _primary,
                            )),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: _primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bolt_rounded, color: _primary, size: 16),
                            const SizedBox(width: 4),
                            Text('+$_xpEarned XP',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14, fontWeight: FontWeight.w800, color: _primary,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _DoneButton(onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DoneButton extends StatefulWidget {
  final VoidCallback onTap;
  const _DoneButton({required this.onTap});

  @override
  State<_DoneButton> createState() => _DoneButtonState();
}

class _DoneButtonState extends State<_DoneButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            'Done',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerCard extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isCorrect;
  final bool isReviewing;
  final VoidCallback onTap;

  const _AnswerCard({
    required this.label,
    required this.isSelected,
    required this.isCorrect,
    required this.isReviewing,
    required this.onTap,
  });

  @override
  State<_AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<_AnswerCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    Color bgColor = AppTheme.surfaceLow;
    Color borderColor = Colors.transparent;
    Widget? trailing;

    if (widget.isReviewing) {
      if (widget.isCorrect) {
        bgColor = const Color(0xFF4CAF50).withValues(alpha: 0.1);
        borderColor = const Color(0xFF4CAF50);
        trailing = const Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50));
      } else if (widget.isSelected) {
        bgColor = const Color(0xFFFF5252).withValues(alpha: 0.1);
        borderColor = const Color(0xFFFF5252);
        trailing = const Icon(Icons.cancel_rounded, color: Color(0xFFFF5252));
      }
    }

    return GestureDetector(
      onTapDown: widget.isReviewing ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.isReviewing
          ? null
          : (_) {
              setState(() => _pressed = false);
              if (widget.isCorrect) {
                HapticFeedback.lightImpact();
              } else {
                HapticFeedback.mediumImpact();
              }
              widget.onTap();
            },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}
