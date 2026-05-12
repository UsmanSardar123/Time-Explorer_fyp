import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NarratorSheet extends StatefulWidget {
  final String text;
  final Color accentColor;
  final String title;

  const NarratorSheet({
    super.key,
    required this.text,
    required this.accentColor,
    required this.title,
  });

  static Future<void> show(
    BuildContext context, {
    required String text,
    required Color accentColor,
    required String title,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NarratorSheet(
        text: text,
        accentColor: accentColor,
        title: title,
      ),
    );
  }

  @override
  State<NarratorSheet> createState() => _NarratorSheetState();
}

class _NarratorSheetState extends State<NarratorSheet> {
  String _displayed = '';
  bool _done = false;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _startTypewriter();
  }

  void _startTypewriter() {
    _timer = Timer.periodic(const Duration(milliseconds: 28), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_index >= widget.text.length) {
        t.cancel();
        setState(() => _done = true);
        return;
      }
      setState(() {
        _displayed += widget.text[_index];
        _index++;
      });
    });
  }

  void _skipToEnd() {
    _timer?.cancel();
    setState(() {
      _displayed = widget.text;
      _done = true;
      _index = widget.text.length;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      maxChildSize: 0.92,
      minChildSize: 0.40,
      builder: (_, controller) => _SheetBody(
        controller: controller,
        accentColor: widget.accentColor,
        title: widget.title,
        displayed: _displayed,
        done: _done,
        onSkip: _skipToEnd,
      ),
    );
  }
}

class _SheetBody extends StatelessWidget {
  final ScrollController controller;
  final Color accentColor;
  final String title;
  final String displayed;
  final bool done;
  final VoidCallback onSkip;

  const _SheetBody({
    required this.controller,
    required this.accentColor,
    required this.title,
    required this.displayed,
    required this.done,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0E0D1F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Icon(Icons.auto_stories_rounded, color: accentColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!done)
                  TextButton(
                    onPressed: onSkip,
                    child: Text(
                      'Skip',
                      style: GoogleFonts.beVietnamPro(
                        color: accentColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(color: accentColor.withValues(alpha: 0.25), height: 1),
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayed,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.88),
                      height: 1.75,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (!done)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '▌',
                        style: TextStyle(color: accentColor, fontSize: 16),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
