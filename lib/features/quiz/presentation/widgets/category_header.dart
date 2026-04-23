import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/quiz_topic.dart';

class CategoryHeader extends StatelessWidget {
  final EpochCategory epoch;

  const CategoryHeader({super.key, required this.epoch});

  static const _labels = {
    EpochCategory.ancient: 'Ancient World',
    EpochCategory.discovery: 'Age of Discovery',
    EpochCategory.modern: 'Modern Era',
    EpochCategory.global: 'Global Perspectives',
  };

  static const _icons = {
    EpochCategory.ancient: Icons.history_edu,
    EpochCategory.discovery: Icons.explore,
    EpochCategory.modern: Icons.public,
    EpochCategory.global: Icons.language,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 12),
      child: Row(
        children: [
          Icon(_icons[epoch], size: 18, color: const Color(0xFF708090)),
          const SizedBox(width: 8),
          Text(
            _labels[epoch]!.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF708090),
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        ],
      ),
    );
  }
}
