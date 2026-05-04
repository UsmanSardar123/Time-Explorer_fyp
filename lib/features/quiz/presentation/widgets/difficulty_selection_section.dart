import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/quiz/domain/entities/quiz_topic.dart';

class DifficultySelectionSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onStart;
  final Function(DifficultyLevel) onDifficultySelected;

  const DifficultySelectionSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onDifficultySelected,
    this.onStart,
  });

  @override
  State<DifficultySelectionSection> createState() => _DifficultySelectionSectionState();
}

class _DifficultySelectionSectionState extends State<DifficultySelectionSection> {
  DifficultyLevel? _selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.psychology_rounded, color: AppTheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _DifficultyChip(
                  level: DifficultyLevel.easy,
                  label: 'Beginner',
                  color: AppTheme.accentGreen,
                  isSelected: _selectedDifficulty == DifficultyLevel.easy,
                  onSelect: () => _selectDifficulty(DifficultyLevel.easy),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DifficultyChip(
                  level: DifficultyLevel.medium,
                  label: 'Enthusiast',
                  color: AppTheme.accentOrange,
                  isSelected: _selectedDifficulty == DifficultyLevel.medium,
                  onSelect: () => _selectDifficulty(DifficultyLevel.medium),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DifficultyChip(
                  level: DifficultyLevel.hard,
                  label: 'Expert',
                  color: AppTheme.error,
                  isSelected: _selectedDifficulty == DifficultyLevel.hard,
                  onSelect: () => _selectDifficulty(DifficultyLevel.hard),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedDifficulty != null ? widget.onStart : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppTheme.outlineVariant.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                'Start Knowledge Check',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDifficulty(DifficultyLevel level) {
    setState(() => _selectedDifficulty = level);
    widget.onDifficultySelected(level);
  }
}

class _DifficultyChip extends StatelessWidget {
  final DifficultyLevel level;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onSelect;

  const _DifficultyChip({
    required this.level,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppTheme.outlineVariant.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: isSelected ? color : AppTheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 16,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? color : AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
