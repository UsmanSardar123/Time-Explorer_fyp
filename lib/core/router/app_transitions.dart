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
