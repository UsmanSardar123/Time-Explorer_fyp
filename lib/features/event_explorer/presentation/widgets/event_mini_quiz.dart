import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/confetti_burst.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import '../../data/datasources/event_quiz_catalog.dart';
import '../../domain/entities/event_quiz_question.dart';

class EventMiniQuiz extends StatefulWidget {
  final String eventId;
  final Color accent;

  const EventMiniQuiz({super.key, required this.eventId, required this.accent});

  @override
  State<EventMiniQuiz> createState() => _EventMiniQuizState();
}

class _EventMiniQuizState extends State<EventMiniQuiz> {
  late final List<EventQuizQuestion> _questions;
  int _index = 0;
  int? _selected;
  bool _xpAwarded = false;
  bool _playConfetti = false;

  @override
  void initState() {
    super.initState();
    _questions = EventQuizCatalog.forEvent(widget.eventId);
  }

  EventQuizQuestion get _current => _questions[_index];

  bool get _alreadyAnswered =>
      context
          .read<GamificationProvider>()
          .progress
          .answeredQuestionIds
          .contains(_current.id);

  Future<void> _onTap(int chosen) async {
    if (_selected != null) return;
    setState(() => _selected = chosen);

    final correct = _current.isCorrect(chosen);
    final awarded = await context
        .read<GamificationProvider>()
        .recordEventQuizAnswer(questionId: _current.id, isCorrect: correct);

    if (mounted) {
      setState(() {
        _xpAwarded = awarded;
        if (awarded) _playConfetti = true;
      });
    }
  }

  void _next() {
    if (_index >= _questions.length - 1) return;
    setState(() {
      _index += 1;
      _selected = null;
      _xpAwarded = false;
      _playConfetti = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return const SizedBox.shrink();
    final q = _current;
    final answered = _selected != null;
    final correct = answered && q.isCorrect(_selected!);

    return Stack(
      children: [
        _quizBody(q, answered, correct),
        Positioned.fill(
          child: ConfettiBurst(
            play: _playConfetti,
            seedColor: widget.accent,
            onComplete: () {
              if (mounted) setState(() => _playConfetti = false);
            },
          ),
        ),
      ],
    );
  }

  Widget _quizBody(EventQuizQuestion q, bool answered, bool correct) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.accent.withValues(alpha: 0.10),
            widget.accent.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(color: widget.accent.withValues(alpha: 0.30), width: 1.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            accent: widget.accent,
            index: _index + 1,
            total: _questions.length,
          ),
          const SizedBox(height: 14),
          Text(
            q.question,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(q.options.length, (i) {
            return _OptionButton(
              label: q.options[i],
              accent: widget.accent,
              state: _stateFor(i, q.correctIndex, answered),
              onTap: () => _onTap(i),
            );
          }),
          if (answered) ...[
            const SizedBox(height: 12),
            _Feedback(
              correct: correct,
              accent: widget.accent,
              explanation: q.explanation,
              xpAwarded: _xpAwarded,
              alreadyAnswered: !_xpAwarded && correct && _alreadyAnswered,
            ),
            if (_index < _questions.length - 1) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _next,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 22),
                  label: Text(
                    'Next question',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.accent,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  _OptionState _stateFor(int i, int correctIdx, bool answered) {
    if (!answered) return _OptionState.idle;
    if (i == correctIdx) return _OptionState.correct;
    if (i == _selected) return _OptionState.wrong;
    return _OptionState.dimmed;
  }
}

enum _OptionState { idle, correct, wrong, dimmed }

class _Header extends StatelessWidget {
  final Color accent;
  final int index;
  final int total;
  const _Header({required this.accent, required this.index, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: const Text('🧠', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 10),
        Text(
          'Quick Quiz',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.onSurface,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$index / $total',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final Color accent;
  final _OptionState state;
  final VoidCallback onTap;

  const _OptionButton({
    required this.label,
    required this.accent,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = _palette(accent, state);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        constraints: const BoxConstraints(minHeight: 64),
        decoration: BoxDecoration(
          color: palette.bg,
          border: Border.all(color: palette.border, width: 1.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: state == _OptionState.idle ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: palette.text,
                      height: 1.3,
                    ),
                  ),
                ),
                if (state == _OptionState.correct)
                  const Icon(Icons.check_circle_rounded,
                      color: Color(0xFF16A34A), size: 26)
                else if (state == _OptionState.wrong)
                  const Icon(Icons.cancel_rounded,
                      color: Color(0xFFDC2626), size: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _OptionPalette _palette(Color accent, _OptionState state) {
    switch (state) {
      case _OptionState.idle:
        return _OptionPalette(
          bg: Colors.white,
          border: accent.withValues(alpha: 0.35),
          text: AppTheme.onSurface,
        );
      case _OptionState.correct:
        return const _OptionPalette(
          bg: Color(0xFFE8F8EE),
          border: Color(0xFF16A34A),
          text: Color(0xFF166534),
        );
      case _OptionState.wrong:
        return const _OptionPalette(
          bg: Color(0xFFFDECEC),
          border: Color(0xFFDC2626),
          text: Color(0xFF991B1B),
        );
      case _OptionState.dimmed:
        return _OptionPalette(
          bg: Colors.white,
          border: AppTheme.outlineVariant,
          text: AppTheme.onSurfaceVariant,
        );
    }
  }
}

class _OptionPalette {
  final Color bg;
  final Color border;
  final Color text;
  const _OptionPalette({required this.bg, required this.border, required this.text});
}

class _Feedback extends StatelessWidget {
  final bool correct;
  final Color accent;
  final String? explanation;
  final bool xpAwarded;
  final bool alreadyAnswered;

  const _Feedback({
    required this.correct,
    required this.accent,
    required this.xpAwarded,
    required this.alreadyAnswered,
    this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final headline = correct
        ? (xpAwarded
            ? '🎉 Correct! +10 Time Energy'
            : alreadyAnswered
                ? '✅ Correct (already answered earlier)'
                : '✅ Correct!')
        : '😅 Not quite — try the next one!';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (correct ? const Color(0xFF16A34A) : const Color(0xFFDC2626))
            .withValues(alpha: 0.10),
        border: Border.all(
          color: (correct ? const Color(0xFF16A34A) : const Color(0xFFDC2626))
              .withValues(alpha: 0.40),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headline,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: correct ? const Color(0xFF166534) : const Color(0xFF991B1B),
            ),
          ),
          if (explanation != null && explanation!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              explanation!,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                height: 1.45,
                color: AppTheme.onSurface.withValues(alpha: 0.85),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
