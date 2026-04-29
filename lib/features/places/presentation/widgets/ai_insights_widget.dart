// FILE: lib/features/places/presentation/widgets/ai_insights_widget.dart
// PURPOSE: Displays AI-generated "Did You Know?" facts with shimmer loading and silent error handling.
// SPRINT: 3 — TASK 3.5

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/widgets/shimmer_box.dart';
import 'package:timeexplorer/features/places/data/services/place_insights_service.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';

class AiInsightsWidget extends StatefulWidget {
  final Place place;

  const AiInsightsWidget({super.key, required this.place});

  @override
  State<AiInsightsWidget> createState() => _AiInsightsWidgetState();
}

class _AiInsightsWidgetState extends State<AiInsightsWidget> {
  late final Future<List<String>> _future;

  @override
  void initState() {
    super.initState();
    _future = PlaceInsightsService().getInsights(widget.place);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmer();
        }
        final facts = snapshot.data ?? [];
        if (facts.isEmpty) return const SizedBox.shrink();
        return _buildContent(facts);
      },
    );
  }

  Widget _buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(width: 160, height: 18, radius: 6),
        const SizedBox(height: 12),
        ...List.generate(3, (_) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ShimmerBox(height: 60, radius: 12),
        )),
      ],
    );
  }

  Widget _buildContent(List<String> facts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Did You Know?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111827),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 6),
            const Text('✨', style: TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 14),
        ...facts.map((fact) => _FactCard(fact: fact)),
      ],
    );
  }
}

class _FactCard extends StatelessWidget {
  final String fact;
  const _FactCard({required this.fact});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4A853).withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fact,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                height: 1.55,
                color: const Color(0xFF5C4010),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
