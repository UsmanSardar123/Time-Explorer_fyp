import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/models/quick_fact_item.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

class QuickFactDetailPage extends StatelessWidget {
  final QuickFactItem fact;

  const QuickFactDetailPage({super.key, required this.fact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _Header(fact: fact),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ValueBadge(fact: fact),
                  const SizedBox(height: 28),
                  _DescriptionSection(fact: fact),
                  if (fact.relatedFacts.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _RelatedFactsSection(facts: fact.relatedFacts, accentColor: fact.accentColor),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header with gradient and back button ──────────────────────────────────────

class _Header extends StatelessWidget {
  final QuickFactItem fact;
  const _Header({required this.fact});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: fact.accentColor,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: Material(
          color: Colors.white.withValues(alpha: 0.15),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: _HeaderBackground(fact: fact),
      ),
      title: Text(
        fact.title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  final QuickFactItem fact;
  const _HeaderBackground({required this.fact});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            fact.accentColor,
            fact.accentColor.withValues(alpha: 0.75),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(fact.icon, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              fact.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white.withValues(alpha: 0.85),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Value badge shown below the header ───────────────────────────────────────

class _ValueBadge extends StatelessWidget {
  final QuickFactItem fact;
  const _ValueBadge({required this.fact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: fact.accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: fact.accentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(fact.icon, size: 18, color: fact.accentColor),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              fact.value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: fact.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Main description section ──────────────────────────────────────────────────

class _DescriptionSection extends StatelessWidget {
  final QuickFactItem fact;
  const _DescriptionSection({required this.fact});

  @override
  Widget build(BuildContext context) {
    final hasDescription = fact.description.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 20,
              decoration: BoxDecoration(
                color: fact.accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'About',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            hasDescription
                ? fact.description
                : 'No additional details are available for this fact.',
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              height: 1.65,
              color: hasDescription
                  ? AppTheme.onSurfaceVariant
                  : AppTheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Related facts list ────────────────────────────────────────────────────────

class _RelatedFactsSection extends StatelessWidget {
  final List<String> facts;
  final Color accentColor;
  const _RelatedFactsSection({required this.facts, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 20,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Related Facts',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...facts.map((f) => _FactCard(text: f, accentColor: accentColor)),
      ],
    );
  }
}

class _FactCard extends StatelessWidget {
  final String text;
  final Color accentColor;
  const _FactCard({required this.text, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                height: 1.55,
                color: AppTheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
