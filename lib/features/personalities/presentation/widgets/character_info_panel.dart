import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/core/models/quick_fact_item.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import '../../domain/entities/character.dart';

class CharacterInfoPanel extends StatelessWidget {
  final Character character;

  const CharacterInfoPanel({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final knownForFact = QuickFactItem(
      title: 'KNOWN FOR',
      value: character.bio.isNotEmpty ? character.bio : character.title,
      icon: Icons.stars_rounded,
      description: [
        if (character.bio.isNotEmpty) character.bio,
        if (character.description.isNotEmpty) character.description,
      ].join('\n\n'),
      accentColor: AppTheme.primaryContainer,
      relatedFacts: character.contributions.take(5).toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildInfoRow(context),
        const SizedBox(height: 24),
        _buildSection(
          title: 'About',
          child: Text(
            character.description,
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              height: 1.6,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: 'Known For',
          child: Semantics(
            label: 'Known For: ${character.bio}. Tap for more details.',
            button: true,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.push('/quick-fact-detail', extra: knownForFact),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppTheme.primaryContainer.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: AppTheme.primaryContainer, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          character.bio,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          size: 16, color: AppTheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: 'Major Contributions',
          child: _buildBulletList(character.contributions),
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: 'Interesting Facts',
          child: _buildFactCards(character.facts),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          character.name,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppTheme.onSurface,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          character.title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    final datesFact = QuickFactItem(
      title: 'LIFESPAN',
      value: '${character.dob} – ${character.dod}',
      icon: Icons.calendar_today_rounded,
      description: [
        'Born: ${character.dob}',
        if (character.dod.isNotEmpty && character.dod != 'Present') 'Died: ${character.dod}',
        if (character.era.isNotEmpty) 'Era: ${character.era}',
        if (character.description.isNotEmpty) character.description,
      ].join('\n\n'),
      accentColor: AppTheme.primaryContainer,
      relatedFacts: character.facts.take(4).toList(),
    );

    final originFact = QuickFactItem(
      title: 'ORIGIN',
      value: character.origin,
      icon: Icons.public_rounded,
      description: [
        if (character.origin.isNotEmpty) 'Origin: ${character.origin}',
        if ((character.nationality ?? '').isNotEmpty) 'Nationality: ${character.nationality}',
        if (character.description.isNotEmpty) character.description,
      ].join('\n\n'),
      accentColor: AppTheme.primaryContainer,
      relatedFacts: character.facts.take(4).toList(),
    );

    final categoryFact = QuickFactItem(
      title: 'CATEGORY',
      value: character.category.displayName,
      icon: character.category.icon,
      description: [
        'Category: ${character.category.displayName}',
        if (character.era.isNotEmpty) 'Era: ${character.era}',
        if (character.bio.isNotEmpty) character.bio,
      ].join('\n\n'),
      accentColor: AppTheme.primaryContainer,
      relatedFacts: character.specialties.take(4).toList(),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildInfoChip(
            context: context,
            icon: Icons.calendar_today_rounded,
            label: '${character.dob} → ${character.dod}',
            fact: datesFact,
          ),
          const SizedBox(width: 12),
          _buildInfoChip(
            context: context,
            icon: Icons.public_rounded,
            label: character.origin,
            fact: originFact,
          ),
          const SizedBox(width: 12),
          _buildInfoChip(
            context: context,
            icon: character.category.icon,
            label: character.category.displayName,
            isCategory: true,
            fact: categoryFact,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required QuickFactItem fact,
    bool isCategory = false,
  }) {
    return Semantics(
      label: '$label. Tap for more details.',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push('/quick-fact-detail', extra: fact),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isCategory
                  ? AppTheme.primaryContainer.withValues(alpha: 0.08)
                  : AppTheme.surfaceLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isCategory
                    ? AppTheme.primaryContainer.withValues(alpha: 0.15)
                    : AppTheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color:
                      isCategory ? AppTheme.primaryContainer : AppTheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isCategory ? AppTheme.primaryContainer : AppTheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 12,
                  color: isCategory
                      ? AppTheme.primaryContainer.withValues(alpha: 0.5)
                      : AppTheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    height: 1.5,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFactCards(List<String> items) {
    return Column(
      children: items.map((item) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_outline_rounded, color: AppTheme.amber, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    height: 1.5,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
