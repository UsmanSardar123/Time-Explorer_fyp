import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/quiz_topic.dart';

class TopicCard extends StatelessWidget {
  final QuizTopic topic;
  final VoidCallback onTap;

  const TopicCard({super.key, required this.topic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: topic.color.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                _TopicIcon(color: topic.color, icon: topic.icon),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              topic.title,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF002366),
                              ),
                            ),
                          ),
                          _DifficultyBadge(level: topic.difficultyLevel),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        topic.description,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF708090),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicIcon extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _TopicIcon({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final DifficultyLevel level;

  const _DifficultyBadge({required this.level});

  static const _labels = {
    DifficultyLevel.easy: 'Easy',
    DifficultyLevel.medium: 'Medium',
    DifficultyLevel.hard: 'Hard',
  };

  static const _colors = {
    DifficultyLevel.easy: Color(0xFF4CAF50),
    DifficultyLevel.medium: Color(0xFFFF9800),
    DifficultyLevel.hard: Color(0xFFE53935),
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[level]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        _labels[level]!,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
