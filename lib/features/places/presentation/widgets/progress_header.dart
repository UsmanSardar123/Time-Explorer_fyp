// FILE: lib/features/places/presentation/widgets/progress_header.dart
// PURPOSE: Shows X-of-Y explored progress bar at the top of the places list for authenticated users.
// SPRINT: 2 — TASK 2.4

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';

class ProgressHeader extends StatelessWidget {
  final int totalPlaces;
  final Set<String> knownPlaceIds;

  const ProgressHeader({
    super.key,
    required this.totalPlaces,
    this.knownPlaceIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (totalPlaces <= 0) return const SizedBox.shrink();
    return Consumer<GamificationProvider>(
      builder: (context, provider, _) {
        final exploredIds = provider.progress.exploredPlaceIds;
        final exploredInScope = knownPlaceIds.isEmpty
            ? exploredIds.length
            : exploredIds.where(knownPlaceIds.contains).length;
        final explored = exploredInScope.clamp(0, totalPlaces);
        final progress = (explored / totalPlaces).clamp(0.0, 1.0);

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$explored of $totalPlaces places explored',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textHighContrast,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryElectric,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: AppTheme.surfaceLow,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryElectric),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
