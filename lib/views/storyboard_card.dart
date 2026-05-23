import 'package:flutter/material.dart';
import 'package:timeexplorer/views/storyboard_view.dart';
import 'package:timeexplorer/services/storyboard_service.dart';

/// A constrained, embedded card container for the Storyboard component.
/// Uses Material 3 dark-mode high contrast to explicitly stand out.
class StoryboardCard extends StatelessWidget {
  final String storyboardId;
  final StoryboardService? service;

  const StoryboardCard({super.key, required this.storyboardId, this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Fix visibility by providing explicit height constraint
      height: 500,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0E1A), // Dark mode background
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF4F46E5), // High-contrast border (Indigo 600)
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.2),
            blurRadius: 16,
            spreadRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: StoryboardStreamView(storyboardId: storyboardId, service: service),
    );
  }
}

