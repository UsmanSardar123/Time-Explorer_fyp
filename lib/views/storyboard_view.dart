import 'package:flutter/material.dart';
import 'package:timeexplorer/models/storyboard_model.dart';
import 'package:timeexplorer/services/storyboard_service.dart';

/// A full-screen, swipeable storyboard viewer with dark-mode Material 3 styling.
///
/// Displays panels from a [Storyboard] in a horizontal [PageView] with a
/// progress indicator, large typography description, and an audio control button.
class StoryboardView extends StatefulWidget {
  final Storyboard storyboard;

  const StoryboardView({super.key, required this.storyboard});

  @override
  State<StoryboardView> createState() => _StoryboardViewState();
}

class _StoryboardViewState extends State<StoryboardView> {
  late final PageController _pageController;
  int _activePanelIndex = 0;

  // ── Dark Theme Palette ────────────────────────────────────────────────────
  static const _bg = Color(0xFF0F0E1A);
  static const _surface = Color(0xFF1A1929);
  static const _surfaceHigh = Color(0xFF242337);
  static const _accent = Color(0xFF4F46E5);
  static const _accentDim = Color(0xFF3525CD);
  static const _textPrimary = Color(0xFFE6E4F4);
  static const _textSecondary = Color(0xFF9B99B8);
  static const _divider = Color(0xFF3A3856);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<StoryboardPanel> get _panels => widget.storyboard.panelsList;
  int get _total => widget.storyboard.totalPanels;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(),
            Expanded(child: _buildPageView()),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _divider, width: 1),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: _textPrimary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.storyboard.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _textPrimary,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.storyboard.era,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_activePanelIndex + 1} / $_total',
              key: const Key('panel-counter'),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Progress Bar ──────────────────────────────────────────────────────────
  Widget _buildProgressBar() {
    final progress = _total > 0 ? (_activePanelIndex + 1) / _total : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          key: const Key('progress-bar'),
          value: progress,
          minHeight: 4,
          backgroundColor: _surfaceHigh,
          valueColor: const AlwaysStoppedAnimation<Color>(_accent),
        ),
      ),
    );
  }

  // ── Page View ─────────────────────────────────────────────────────────────
  Widget _buildPageView() {
    if (_panels.isEmpty) {
      return const Center(
        child: Text(
          'No panels available.',
          style: TextStyle(color: _textSecondary, fontSize: 16),
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: _panels.length,
      onPageChanged: (index) {
        setState(() => _activePanelIndex = index);
      },
      itemBuilder: (context, index) => _buildPanel(_panels[index]),
    );
  }

  // ── Single Panel ──────────────────────────────────────────────────────────
  Widget _buildPanel(StoryboardPanel panel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        children: [
          // Image placeholder
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _divider, width: 1),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E1D30), Color(0xFF14132A)],
                ),
              ),
              child: panel.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        panel.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      ),
                    )
                  : _imagePlaceholder(),
            ),
          ),
          const SizedBox(height: 20),
          // Text container
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _divider, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _accentDim.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Panel ${panel.panelNumber}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _accent,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Text(
                      panel.description,
                      key: const Key('panel-description'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                        height: 1.5,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Audio control button
          _buildAudioButton(panel),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 48, color: _textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            'Panel Illustration',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _textSecondary.withValues(alpha: 0.5),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioButton(StoryboardPanel panel) {
    final hasAudio = panel.audioUrl.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        key: const Key('audio-button'),
        onPressed: hasAudio ? () {} : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasAudio ? _accent : _surfaceHigh,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _surfaceHigh,
          disabledForegroundColor: _textSecondary.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        icon: Icon(
          hasAudio ? Icons.play_arrow_rounded : Icons.volume_off_rounded,
          size: 24,
        ),
        label: Text(
          hasAudio ? 'Play Narration' : 'No Audio Available',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// A wrapper that streams a [Storyboard] by ID from Firestore and renders
/// [StoryboardView] once data arrives.
///
/// Accepts an optional [StoryboardService] for dependency injection.
class StoryboardStreamView extends StatelessWidget {
  final String storyboardId;
  final StoryboardService? service;

  const StoryboardStreamView({
    super.key,
    required this.storyboardId,
    this.service,
  });

  static const _bg = Color(0xFF0F0E1A);
  static const _accent = Color(0xFF4F46E5);
  static const _textSecondary = Color(0xFF9B99B8);

  @override
  Widget build(BuildContext context) {
    final svc = service ?? StoryboardService();

    return StreamBuilder<Storyboard?>(
      stream: svc.streamStoryboardById(storyboardId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: _bg,
            body: Center(
              child: CircularProgressIndicator(color: _accent),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: _bg,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: _textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load storyboard',
                    style: const TextStyle(color: _textSecondary, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        final storyboard = snapshot.data ?? Storyboard(
          id: storyboardId,
          title: 'The Golden Age of Discovery',
          era: 'Historical Era',
          totalPanels: 3,
          panelsList: [
            StoryboardPanel(
              panelNumber: 1,
              imageUrl: '',
              description: 'A grand civilization emerges, pushing the boundaries of knowledge and human endeavor.',
              audioUrl: '',
            ),
            StoryboardPanel(
              panelNumber: 2,
              imageUrl: '',
              description: 'Innovations in architecture and science pave the way for future generations.',
              audioUrl: '',
            ),
            StoryboardPanel(
              panelNumber: 3,
              imageUrl: '',
              description: 'Their legacy remains etched in history, a testament to human resilience.',
              audioUrl: '',
            ),
          ],
        );

        return StoryboardView(storyboard: storyboard);
      },
    );
  }
}
