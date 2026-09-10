import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
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
      secondary: AppColors.accent,
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
    final bool isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[colors],
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: scaffold,
        surfaceTintColor: Colors.transparent,
        foregroundColor: onSurface,
        toolbarHeight: 64,
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? Colors.white : AppColors.darkSurface,
        hintStyle: textTheme.bodyMedium?.copyWith(color: muted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: line),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: AppColors.accent, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: scheme.error, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentDeep,
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          foregroundColor: onSurface,
          side: BorderSide(color: line),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
          textStyle: textTheme.labelLarge,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: onSurface,
        actionTextColor: AppColors.accent,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: surface),
        insetPadding: const EdgeInsets.all(AppSpacing.md),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.field),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
        circularTrackColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(color: line, space: 1, thickness: 1),
      dividerColor: line,
      iconTheme: IconThemeData(color: onSurface, size: AppSpacing.icon),
      drawerTheme: DrawerThemeData(
        backgroundColor: scaffold,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(AppRadius.lg),
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: onSurface,
          borderRadius: AppRadius.tile,
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: surface),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
