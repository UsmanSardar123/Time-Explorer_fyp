import 'package:flutter/material.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final bool useGradient;
  final Gradient? gradient;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.useGradient = false,
    this.gradient,
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _pressed = false;

  Gradient get _resolvedGradient =>
      widget.gradient ?? AppTheme.cyberGradient;

  @override
  Widget build(BuildContext context) {
    final useGrad = widget.useGradient || widget.gradient != null;

    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.isLoading
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onPressed();
            },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          decoration: useGrad
              ? BoxDecoration(
                  gradient: _resolvedGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  boxShadow: _pressed
                      ? AppTheme.glowShadow(AppTheme.primaryElectric, intensity: 0.5, blur: 20)
                      : AppTheme.glowShadow(AppTheme.primaryElectric, intensity: 0.2, blur: 10),
                )
              : null,
          child: useGrad ? _gradientContent() : _elevatedContent(),
        ),
      ),
    );
  }

  Widget _gradientContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.isLoading)
            const SizedBox(
              height: 20, width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
            )
          else ...[
            if (widget.icon != null) ...[
              Icon(widget.icon, size: 18, color: Colors.black),
              const SizedBox(width: 8),
            ],
            Text(
              widget.text,
              style: AppTheme.headlineMedium.copyWith(
                fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _elevatedContent() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: widget.backgroundColor != null
            ? ElevatedButton.styleFrom(backgroundColor: widget.backgroundColor)
            : null,
        child: widget.isLoading
            ? const SizedBox(
                height: 20, width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(widget.text,
                      style: widget.textColor != null ? TextStyle(color: widget.textColor) : null),
                ],
              ),
      ),
    );
  }
}
