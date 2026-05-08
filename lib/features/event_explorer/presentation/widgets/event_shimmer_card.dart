import 'package:flutter/material.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/shimmer_box.dart';

class EventShimmerCard extends StatelessWidget {
  const EventShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMD, vertical: AppTheme.spaceSM),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        color: AppTheme.surfaceLow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        child: Stack(
          children: [
            const ShimmerBox(width: double.infinity, height: double.infinity, radius: 0),
            Positioned(
              top: 12,
              left: 12,
              child: ShimmerBox(
                width: 120,
                height: 22,
                radius: 20,
              ),
            ),
            const Positioned(
              left: 14,
              right: 14,
              bottom: 36,
              child: ShimmerBox(width: 200, height: 18, radius: 6),
            ),
            const Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: ShimmerBox(width: 140, height: 14, radius: 6),
            ),
          ],
        ),
      ),
    );
  }
}

class EventShimmerList extends StatelessWidget {
  const EventShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (_, __) => const EventShimmerCard(),
    );
  }
}
