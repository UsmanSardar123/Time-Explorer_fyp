import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _FadeSlideTransitionsBuilder extends PageTransitionsBuilder {
  const _FadeSlideTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    final slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
    return FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
  }
}

class AppTheme {
  // ── Brand Palette — Indigo EdTech ─────────────────────────────────────────
  static const Color primary            = Color(0xFF3525CD); // Indigo 700
  static const Color primaryContainer   = Color(0xFF4F46E5); // Indigo 600
  static const Color background         = Color(0xFFFAF8FF); // Warm white
  static const Color surfaceLowest      = Color(0xFFFFFFFF);
  static const Color surfaceLow         = Color(0xFFF4F3FB);
  static const Color surface            = Color(0xFFEEEDF5);
  static const Color surfaceHigh        = Color(0xFFE8E7EF);
  static const Color surfaceHighest     = Color(0xFFE2E2E9);
  static const Color onSurface         = Color(0xFF1A1B21);
  static const Color onSurfaceVariant  = Color(0xFF464555);
  static const Color outlineVariant    = Color(0xFFC7C4D8);
  static const Color amber             = Color(0xFFF59E0B); // XP / streak
  static const Color amberContainer   = Color(0xFFFFF3CD);
  static const Color error             = Color(0xFFB00020);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3525CD), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF3525CD), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFB923C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Backward-Compatible Aliases ───────────────────────────────────────────
  static const Color primaryElectric   = primaryContainer;
  static const Color accentNeon        = amber;
  static const Color streakGold        = amber;
  static const Color xpOrange          = amber;
  static const Color deepSpace         = background;
  static const Color surfaceCyber      = surfaceLow;
  static const Color textHighContrast  = onSurface;
  static const Color textDimmed        = onSurfaceVariant;
  static const Color errorNeon         = error;
  static const Color deepNavy          = primary;
  static const Color primaryColor      = primary;
  static const Color secondaryColor    = amber;
  static const Color accentOrange      = amber;
  static const Color accentGreen       = Color(0xFF059669);
  static const Color textPrimary       = onSurface;
  static const Color scaffoldBackgroundColor = background;

  static const LinearGradient cyberGradient    = primaryGradient;
  static const LinearGradient neonGradient     = amberGradient;
  static const LinearGradient surfaceGradient  = primaryGradient;
  static const LinearGradient goldGradient     = amberGradient;
  static const LinearGradient deepSpaceGradient = primaryGradient;

  // ── Typography Tokens ─────────────────────────────────────────────────────
  static TextStyle get displayHero => GoogleFonts.plusJakartaSans(
        fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0, color: onSurface,
      );

  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
        fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: onSurface,
      );

  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
        fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: onSurface,
      );

  static TextStyle get labelGlow => GoogleFonts.plusJakartaSans(
        fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.4, color: primaryContainer,
      );

  static TextStyle get bodySubtle => GoogleFonts.beVietnamPro(
        fontSize: 14, fontWeight: FontWeight.w400, color: onSurfaceVariant,
      );

  // ── Spacing / Radius Tokens ───────────────────────────────────────────────
  static const double spaceXS = 4;
  static const double spaceSM = 8;
  static const double spaceMD = 16;
  static const double spaceLG = 24;
  static const double spaceXL = 32;
  static const double radiusSM = 12;
  static const double radiusMD = 16;
  static const double radiusLG = 24;

  // ── Decoration Helpers ────────────────────────────────────────────────────
  static List<BoxShadow> glowShadow(
    Color color, {
    double intensity = 0.15,
    double blur = 16,
    double spread = 0,
  }) =>
      [BoxShadow(color: color.withValues(alpha: intensity), blurRadius: blur, spreadRadius: spread)];

  static BoxDecoration cardBox({
    double radius = 16,
    Color? bg,
    bool border = false,
  }) =>
      BoxDecoration(
        color: bg ?? surfaceLowest,
        borderRadius: BorderRadius.circular(radius),
        border: border ? Border.all(color: outlineVariant, width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // neonBox kept for backward compat — maps to cardBox with border
  static BoxDecoration neonBox({
    Color? borderColor,
    double radius = 16,
    Color? background,
    Gradient? gradient,
  }) =>
      BoxDecoration(
        color: gradient == null ? (background ?? surfaceLow) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: (borderColor ?? primaryContainer).withValues(alpha: 0.2),
          width: 1.5,
        ),
      );

  // ── Light Theme ────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = GoogleFonts.beVietnamProTextTheme().apply(
      bodyColor: onSurface,
      displayColor: onSurface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primaryContainer,
        primaryContainer: surfaceLow,
        secondary: amber,
        surface: surfaceLowest,
        surfaceContainerLowest: surfaceLowest,
        surfaceContainerLow: surfaceLow,
        surfaceContainer: surface,
        surfaceContainerHigh: surfaceHigh,
        surfaceContainerHighest: surfaceHighest,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outlineVariant,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      textTheme: base,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: onSurface),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceLowest,
        elevation: 0,
        shadowColor: primary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: outlineVariant, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outlineVariant, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryContainer, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        hintStyle: GoogleFonts.beVietnamPro(color: outlineVariant, fontSize: 15),
        labelStyle: GoogleFonts.plusJakartaSans(color: onSurfaceVariant, fontSize: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceLowest,
        indicatorColor: primaryContainer.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? primaryContainer : onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return IconThemeData(
            color: active ? primaryContainer : onSurfaceVariant,
            size: 24,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceLow,
        selectedColor: primaryContainer.withValues(alpha: 0.15),
        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: onSurface),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
      dividerTheme: const DividerThemeData(color: outlineVariant, thickness: 1),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _FadeSlideTransitionsBuilder(),
          TargetPlatform.iOS: _FadeSlideTransitionsBuilder(),
        },
      ),
    );
  }

  // ── Dark Theme ─────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    const darkBg          = Color(0xFF0F0E1A);
    const darkSurface     = Color(0xFF1A1929);
    const darkSurfaceHigh = Color(0xFF242337);
    const darkOnSurface   = Color(0xFFE6E4F4);
    const darkOnVariant   = Color(0xFF9B99B8);
    const darkOutline     = Color(0xFF3A3856);

    final base = GoogleFonts.beVietnamProTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: darkOnSurface,
      displayColor: darkOnSurface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryContainer,
      scaffoldBackgroundColor: darkBg,
      colorScheme: ColorScheme.dark(
        primary: primaryContainer,
        secondary: amber,
        surface: darkSurface,
        surfaceContainerLow: darkSurface,
        surfaceContainer: darkSurfaceHigh,
        onSurface: darkOnSurface,
        onSurfaceVariant: darkOnVariant,
        outline: darkOutline,
        error: error,
        onPrimary: Colors.white,
      ),
      textTheme: base,
      appBarTheme: AppBarTheme(
        backgroundColor: darkBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: darkOnSurface),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: darkOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkOutline, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: primaryContainer.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? primaryContainer : darkOnVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return IconThemeData(
            color: active ? primaryContainer : darkOnVariant,
            size: 24,
          );
        }),
      ),
    );
  }
}
