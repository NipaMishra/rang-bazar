import 'package:flutter/material.dart';

/// Brand palette sampled from the RangBazaar lockup.
abstract final class AppColors {
  static const Color navy = Color(0xFF1A2744);
  static const Color navyDeep = Color(0xFF0F1624);
  static const Color ivory = Color(0xFFFFF6F0);
  static const Color cream = Color(0xFFF5EFE8);
  static const Color pink = Color(0xFFE23D6B);
  static const Color coral = Color(0xFFFF6B4A);
  static const Color marigold = Color(0xFFFFC53D);
  static const Color teal = Color(0xFF2BBBAD);
  static const Color sky = Color(0xFF4EA3F0);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightMuted = Color(0xFF5C6578);
  static const Color lightLine = Color(0xFFE8DFD6);

  static const Color darkSurface = Color(0xFF1A2436);
  static const Color darkMuted = Color(0xFFB8B3AB);
  static const Color darkLine = Color(0xFF2C3850);

  static const LinearGradient cta = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[pink, coral],
  );

  static const LinearGradient fest = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF1A2744), Color(0xFF3B2158), Color(0xFFE23D6B)],
  );
}

@immutable
class RangBazaarColors extends ThemeExtension<RangBazaarColors> {
  const RangBazaarColors({
    required this.success,
    required this.warning,
    required this.cardShadow,
    required this.imageFill,
    required this.chipFill,
  });

  final Color success;
  final Color warning;
  final Color cardShadow;
  final Color imageFill;
  final Color chipFill;

  static const RangBazaarColors light = RangBazaarColors(
    success: Color(0xFF1F8A70),
    warning: AppColors.marigold,
    cardShadow: Color(0x241A2744),
    imageFill: Color(0xFFF3EEE8),
    chipFill: Color(0xFFF7EFE8),
  );

  static const RangBazaarColors dark = RangBazaarColors(
    success: Color(0xFF4ECDC4),
    warning: AppColors.marigold,
    cardShadow: Color(0x00000000),
    imageFill: Color(0xFF222C40),
    chipFill: Color(0xFF243049),
  );

  @override
  RangBazaarColors copyWith({
    Color? success,
    Color? warning,
    Color? cardShadow,
    Color? imageFill,
    Color? chipFill,
  }) {
    return RangBazaarColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      cardShadow: cardShadow ?? this.cardShadow,
      imageFill: imageFill ?? this.imageFill,
      chipFill: chipFill ?? this.chipFill,
    );
  }

  @override
  RangBazaarColors lerp(ThemeExtension<RangBazaarColors>? other, double t) {
    if (other is! RangBazaarColors) return this;
    return RangBazaarColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      imageFill: Color.lerp(imageFill, other.imageFill, t)!,
      chipFill: Color.lerp(chipFill, other.chipFill, t)!,
    );
  }
}

extension RangBazaarColorsX on BuildContext {
  RangBazaarColors get rangColors =>
      Theme.of(this).extension<RangBazaarColors>() ?? RangBazaarColors.light;
}
