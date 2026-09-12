import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/places/data/services/place_storyboard_service.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/domain/entities/place_storyboard.dart';

class PlaceStoryboardWidget extends StatefulWidget {
  final Place place;
  final PlaceStoryboardService? service;

  const PlaceStoryboardWidget({
    super.key,
    required this.place,
    this.service,
  });

  @override
  State<PlaceStoryboardWidget> createState() => _PlaceStoryboardWidgetState();
}

class _PlaceStoryboardWidgetState extends State<PlaceStoryboardWidget> {
  late final PlaceStoryboardService _service;
  late Future<PlaceStoryboard> _future;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? PlaceStoryboardService();
    _future = _load();
  }

  Future<PlaceStoryboard> _load({bool regenerate = false}) =>
      _service.load(widget.place, forceRefresh: regenerate);

  void _retry({bool regenerate = false}) {
    setState(() => _future = _load(regenerate: regenerate));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlaceStoryboard>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _StoryboardLoading();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _StoryboardError(onRetry: _retry);
        }
        return _StoryboardContent(
          storyboard: snapshot.data!,
          onRegenerate: () => _retry(regenerate: true),
        );
      },
    );
  }
}

class _StoryboardLoading extends StatelessWidget {
  const _StoryboardLoading();

  @override
  Widget build(BuildContext context) {
    return _StoryboardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: AppTheme.amber, size: 28),
          const SizedBox(height: 14),
          Text('Creating your story...', style: _titleStyle()),
          const SizedBox(height: 6),
          Text('Discovering what makes this place special.', style: _bodyStyle()),
          const SizedBox(height: 24),
          const LinearProgressIndicator(minHeight: 3),
        ],
      ),
    );
  }
}

class _StoryboardError extends StatelessWidget {
  final VoidCallback onRetry;
  const _StoryboardError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return _StoryboardShell(
      child: Column(
        children: [
          const Icon(Icons.auto_awesome_outlined, color: AppTheme.onSurfaceVariant, size: 32),
          const SizedBox(height: 10),
          Text("Couldn't create the storyboard right now.", style: _titleStyle(), textAlign: TextAlign.center),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _StoryboardContent extends StatelessWidget {
  final PlaceStoryboard storyboard;
  final VoidCallback onRegenerate;

  const _StoryboardContent({required this.storyboard, required this.onRegenerate});

  @override
  Widget build(BuildContext context) {
    return _StoryboardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(storyboard.title, style: _titleStyle(fontSize: 20))),
              IconButton(
                tooltip: 'Regenerate storyboard',
                onPressed: onRegenerate,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                color: AppTheme.primaryElectric,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          Text(storyboard.subtitle, style: _subtitleStyle()),
          const SizedBox(height: 12),
          Text(storyboard.intro, style: _bodyStyle()),
          const SizedBox(height: 20),
          ...storyboard.sections.map(_StoryboardSectionView.new),
        ],
      ),
    );
  }
}

class _StoryboardSectionView extends StatelessWidget {
  final PlaceStoryboardSection section;
  const _StoryboardSectionView(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_iconFor(section.type), color: AppTheme.primaryElectric, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(section.title, style: _titleStyle(fontSize: 15)),
                if (section.text.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(section.text, style: _bodyStyle()),
                ],
                if (section.items.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  ...section.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• $item', style: _bodyStyle()),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryboardShell extends StatelessWidget {
  final Widget child;
  const _StoryboardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryElectric.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 14, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

IconData _iconFor(String type) {
  switch (type.toLowerCase()) {
    case 'history':
      return Icons.account_balance_rounded;
    case 'highlights':
      return Icons.visibility_rounded;
    case 'fact':
      return Icons.lightbulb_rounded;
    case 'tip':
      return Icons.explore_rounded;
    default:
      return Icons.place_rounded;
  }
}

TextStyle _titleStyle({double fontSize = 17}) => GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: const Color(0xFF111827),
    );

TextStyle _subtitleStyle() => GoogleFonts.beVietnamPro(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppTheme.primaryElectric,
    );

TextStyle _bodyStyle() => GoogleFonts.beVietnamPro(
      fontSize: 13,
      height: 1.55,
      color: const Color(0xFF4B5563),
    );
