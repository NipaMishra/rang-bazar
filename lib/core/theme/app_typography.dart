import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextTheme textTheme(Brightness brightness) {
    final Color body = brightness == Brightness.dark
        ? AppColors.cream
        : AppColors.navy;
    final Color muted = brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.lightMuted;

    final TextTheme base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
    ).textTheme;

    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: body,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: body,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: body,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: body,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: body,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: body,
      ),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.45, color: body),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.45, color: body),
      bodySmall: base.bodySmall?.copyWith(height: 1.4, color: muted),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}
