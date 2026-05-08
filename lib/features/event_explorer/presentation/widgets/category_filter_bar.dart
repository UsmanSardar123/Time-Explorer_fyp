import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import '../../domain/entities/event_category.dart';

class CategoryFilterBar extends StatelessWidget {
  final EventCategory? selected;
  final ValueChanged<EventCategory?> onSelect;

  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMD),
        children: [
          _Chip(label: 'All', color: AppTheme.primary, isSelected: selected == null, onTap: () => onSelect(null)),
          ...EventCategory.values.map((cat) => _Chip(
                label: cat.displayName,
                color: cat.color,
                isSelected: selected == cat,
                onTap: () => onSelect(cat),
              )),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.color, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : AppTheme.surfaceLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : AppTheme.outlineVariant, width: 1.5),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
