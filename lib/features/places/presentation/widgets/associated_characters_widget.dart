// FILE: lib/features/places/presentation/widgets/associated_characters_widget.dart
// PURPOSE: Loads characters by ID and renders horizontal cards that bridge into the Chat module.
// SPRINT: 3 — TASK 3.7

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/personalities/data/repositories/character_firestore_repository.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';

class AssociatedCharactersWidget extends StatefulWidget {
  final List<String> characterIds;
  final String placeName;

  const AssociatedCharactersWidget({
    super.key,
    required this.characterIds,
    required this.placeName,
  });

  @override
  State<AssociatedCharactersWidget> createState() =>
      _AssociatedCharactersWidgetState();
}

class _AssociatedCharactersWidgetState
    extends State<AssociatedCharactersWidget> {
  late final Future<List<Character>> _future;
  final _repo = CharacterFirestoreRepository();

  @override
  void initState() {
    super.initState();
    _future = _loadCharacters();
  }

  Future<List<Character>> _loadCharacters() async {
    final results = await Future.wait(
      widget.characterIds.map((id) => _repo.getById(id)),
    );
    return results.whereType<Character>().toList();
  }

  void _openChat(BuildContext context, Character character) {
    context.push('/personality-chat', extra: {
      'character': character,
      'initialMessage':
          'Tell me about your experiences with ${widget.placeName}.',
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Character>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        final characters = snapshot.data ?? [];
        if (characters.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.record_voice_over_rounded,
                    color: AppTheme.primaryColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Ask the Guide',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Chat with historical figures connected to this place',
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final c = characters[index];
                  return _CharacterCard(
                    character: c,
                    onTap: () => _openChat(context, c),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const _CharacterCard({required this.character, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppTheme.surfaceLow,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: character.imageUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => const Icon(
                    Icons.person_rounded,
                    color: AppTheme.onSurfaceVariant,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              character.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              character.era,
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
