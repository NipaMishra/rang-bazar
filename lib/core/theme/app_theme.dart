import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(
    brightness: Brightness.light,
    colors: RangBazaarColors.light,
    scaffold: AppColors.ivory,
    surface: AppColors.lightSurface,
    onSurface: AppColors.navy,
    muted: AppColors.lightMuted,
    line: AppColors.lightLine,
    primary: AppColors.navy,
    onPrimary: Colors.white,
  );

  static ThemeData dark() => _build(
    brightness: Brightness.dark,
    colors: RangBazaarColors.dark,
    scaffold: AppColors.navyDeep,
    surface: AppColors.darkSurface,
    onSurface: AppColors.cream,
    muted: AppColors.darkMuted,
    line: AppColors.darkLine,
    primary: AppColors.pink,
    onPrimary: Colors.white,
  );

  static ThemeData _build({
    required Brightness brightness,
    required RangBazaarColors colors,
    required Color scaffold,
    required Color surface,
    required Color onSurface,
    required Color muted,
    required Color line,
    required Color primary,
    required Color onPrimary,
  }) {
    final ColorScheme scheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: AppColors.pink,
      onSecondary: Colors.white,
      tertiary: AppColors.teal,
      onTertiary: Colors.white,
      error: const Color(0xFFC62828),
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: muted,
      outline: line,
      outlineVariant: line,
    );

    final TextTheme textTheme = AppTypography.textTheme(brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[colors],
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: scaffold,
        foregroundColor: onSurface,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: brightness == Brightness.light ? 0 : 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light
            ? const Color(0xFFF4EEE8)
            : AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: AppColors.coral, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          backgroundColor: AppColors.pink,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
          textStyle: textTheme.labelLarge,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: onSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: surface),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.field),
      ),
      dividerColor: line,
      iconTheme: IconThemeData(color: onSurface, size: AppSpacing.icon),
    );
  }
}
