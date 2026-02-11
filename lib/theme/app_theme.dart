import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _seedColor = Colors.teal[400]!;

ThemeData buildAppTheme([Brightness brightness = Brightness.light]) {
  final scheme = brightness == Brightness.dark
      ? ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.dark)
      : ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.light);

  final baseTextTheme = brightness == Brightness.dark
      ? Typography.material2021().white
      : Typography.material2021().black;

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: GoogleFonts.montserratTextTheme(baseTextTheme),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: scheme.surfaceContainerHighest,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: (brightness == Brightness.dark
              ? scheme.surfaceContainerHigh
              : Colors.white)
          .withValues(alpha: 0.8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 2,
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

/// Glassmorphism card: blur + semi-transparent background.
Widget buildGlassCard({
  required BuildContext context,
  required Widget child,
  double borderRadius = 16,
  double opacity = 0.8,
  double blurSigma = 10,
  EdgeInsetsGeometry? padding,
}) {
  final color = Theme.of(context).colorScheme.surface;
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: opacity.clamp(0.0, 1.0)),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}
