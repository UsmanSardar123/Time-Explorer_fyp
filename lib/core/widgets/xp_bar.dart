import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

class XpBar extends StatefulWidget {
  final double progress;
  final int totalXP;
  final int xpToNext;
  final Color? color;
  final int animDelayMs;

  const XpBar({
    super.key,
    required this.progress,
    required this.totalXP,
    required this.xpToNext,
    this.color,
    this.animDelayMs = 300,
  });

  @override
  State<XpBar> createState() => _XpBarState();
}

class _XpBarState extends State<XpBar> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  late Animation<double> _fill;

  @override
  void initState() {
    super.initState();
    _fill = Tween<double>(begin: 0.0, end: widget.progress.clamp(0.0, 1.0))
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.animDelayMs), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void didUpdateWidget(XpBar old) {
    super.didUpdateWidget(old);
    if (old.progress != widget.progress) {
      _fill = Tween<double>(begin: _fill.value, end: widget.progress.clamp(0.0, 1.0))
          .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.color ?? AppTheme.primaryElectric;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.totalXP} XP',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, fontWeight: FontWeight.w700, color: c)),
            Text('${widget.xpToNext} to next level',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: AppTheme.textDimmed)),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(builder: (_, constraints) {
          return AnimatedBuilder(
            animation: _fill,
            builder: (_, child) => Stack(children: [
              Container(
                height: 10,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Container(
                height: 10,
                width: (constraints.maxWidth * _fill.value).clamp(0.0, constraints.maxWidth),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [c, c.withValues(alpha: 0.65)]),
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: AppTheme.glowShadow(c, intensity: 0.45, blur: 8),
                ),
              ),
            ]),
          );
        }),
      ],
    );
  }
}
