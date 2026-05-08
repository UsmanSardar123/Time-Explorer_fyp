import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTransitions {
  static const _duration       = Duration(milliseconds: 260);
  static const _fadeDuration   = Duration(milliseconds: 280);
  static const _portalDuration = Duration(milliseconds: 260);

  /// Slide from right + fade — sub-screens and drill-downs.
  static CustomTransitionPage<T> slide<T>(Widget child, GoRouterState state) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: _duration,
      reverseTransitionDuration: _duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slide = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        final fade = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn));
        return SlideTransition(
          position: animation.drive(slide),
          child: FadeTransition(opacity: animation.drive(fade), child: child),
        );
      },
    );
  }

  /// Scale + fade + micro-rotation — immersive detail entries
  /// (place details, personality details, era details).
  static CustomTransitionPage<T> portal<T>(Widget child, GoRouterState state) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: _portalDuration,
      reverseTransitionDuration: _duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scale = Tween<double>(begin: 0.90, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack));
        final fade = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn));
        final rotate = Tween<double>(begin: 0.018, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOutCubic));

        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) => Opacity(
            opacity: fade.evaluate(animation).clamp(0.0, 1.0),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(
                scale.evaluate(animation), scale.evaluate(animation), 1.0,
              )..rotateZ(rotate.evaluate(animation) * math.pi),
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Pure fade — root-level screens (home, auth, admin, splash).
  static CustomTransitionPage<T> fade<T>(Widget child, GoRouterState state) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: _fadeDuration,
      reverseTransitionDuration: _fadeDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(
            Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }

  /// Dramatic scale-from-deep + fade — cinematic era/event reveal.
  static CustomTransitionPage<T> eraReveal<T>(Widget child, GoRouterState state) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scale = Tween<double>(begin: 0.80, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack));
        final fade = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut));
        return FadeTransition(
          opacity: animation.drive(fade),
          child: ScaleTransition(scale: animation.drive(scale), child: child),
        );
      },
    );
  }

  /// Navigator.push route with a category-accent color flash + scale-in.
  /// Used for event detail navigation inside EventExplorer.
  static Route<T> categoryReveal<T>(Widget child, Color accentColor) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) {
        final scale = Tween<double>(begin: 0.88, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack));
        final fade = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut));
        final flashOpacity = Tween<double>(begin: 0.35, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut));
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) => Stack(
            children: [
              Opacity(
                opacity: fade.evaluate(animation),
                child: Transform.scale(
                  scale: scale.evaluate(animation),
                  child: child,
                ),
              ),
              IgnorePointer(
                child: Opacity(
                  opacity: flashOpacity.evaluate(animation).clamp(0.0, 1.0),
                  child: ColoredBox(
                    color: accentColor,
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Slide up from bottom + fade — modal-style screens (quiz, chat, progress).
  static CustomTransitionPage<T> bottomUp<T>(Widget child, GoRouterState state) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: _duration,
      reverseTransitionDuration: _duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slide = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        final fade = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn));
        return SlideTransition(
          position: animation.drive(slide),
          child: FadeTransition(opacity: animation.drive(fade), child: child),
        );
      },
    );
  }
}
