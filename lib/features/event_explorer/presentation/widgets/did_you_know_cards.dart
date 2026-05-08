import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

class DidYouKnowCards extends StatefulWidget {
  final List<String> facts;
  final String fullText;
  final Color accent;

  const DidYouKnowCards({
    super.key,
    required this.facts,
    required this.fullText,
    required this.accent,
  });

  @override
  State<DidYouKnowCards> createState() => _DidYouKnowCardsState();
}

class _DidYouKnowCardsState extends State<DidYouKnowCards> {
  final PageController _controller = PageController(viewportFraction: 0.92);
  int _index = 0;
  bool _expanded = false;

  List<String> get _safeFacts =>
      widget.facts.isNotEmpty ? widget.facts : _splitFromText();

  List<String> _splitFromText() {
    final cleaned = widget.fullText.replaceAll(RegExp(r'[#*_`>]'), '').trim();
    final parts = cleaned.split(RegExp(r'(?<=[.!?])\s+'));
    return parts.where((p) => p.length > 10).take(5).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final facts = _safeFacts;
    if (facts.isEmpty && widget.fullText.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(accent: widget.accent),
        const SizedBox(height: 14),
        if (facts.isNotEmpty)
          _CardsCarousel(
            facts: facts,
            accent: widget.accent,
            controller: _controller,
            onChanged: (i) => setState(() => _index = i),
          ),
        if (facts.length > 1) ...[
          const SizedBox(height: 12),
          _Dots(count: facts.length, current: _index, color: widget.accent),
        ],
        const SizedBox(height: 16),
        _ReadMore(
          expanded: _expanded,
          fullText: widget.fullText,
          accent: widget.accent,
          onToggle: () => setState(() => _expanded = !_expanded),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final Color accent;
  const _Header({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: const Text('🎯', style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: 10),
        Text(
          'Did you know?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _CardsCarousel extends StatelessWidget {
  final List<String> facts;
  final Color accent;
  final PageController controller;
  final ValueChanged<int> onChanged;

  const _CardsCarousel({
    required this.facts,
    required this.accent,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: controller,
        itemCount: facts.length,
        onPageChanged: onChanged,
        itemBuilder: (_, i) => _FactCard(
          text: facts[i],
          index: i + 1,
          total: facts.length,
          accent: accent,
        ),
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  final String text;
  final int index;
  final int total;
  final Color accent;

  const _FactCard({
    required this.text,
    required this.index,
    required this.total,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: 0.10),
              accent.withValues(alpha: 0.04),
            ],
          ),
          border: Border.all(color: accent.withValues(alpha: 0.30), width: 1.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'FACT $index / $total',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                  height: 1.45,
                ),
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int current;
  final Color color;

  const _Dots({required this.count, required this.current, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? color : color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _ReadMore extends StatelessWidget {
  final bool expanded;
  final String fullText;
  final Color accent;
  final VoidCallback onToggle;

  const _ReadMore({
    required this.expanded,
    required this.fullText,
    required this.accent,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (fullText.trim().isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Row(
              children: [
                Icon(
                  expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: accent,
                ),
                const SizedBox(width: 6),
                Text(
                  expanded ? 'Hide full story' : 'Read more',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(AppTheme.spaceLG),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: MarkdownBody(
              data: fullText,
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.beVietnamPro(
                  fontSize: 15,
                  height: 1.6,
                  color: AppTheme.onSurface.withValues(alpha: 0.85),
                ),
              ),
            ),
          ),
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 240),
        ),
      ],
    );
  }
}
