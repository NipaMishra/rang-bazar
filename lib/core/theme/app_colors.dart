import 'package:flutter/material.dart';

/// Brand palette sampled from the RangBazaar lockup.
abstract final class AppColors {
  static const Color navy = Color(0xFF1A2744);
  static const Color navyDeep = Color(0xFF0F1624);
  static const Color ivory = Color(0xFFFFFFFF);
  static const Color cream = Color(0xFFF5EFE8);
  static const Color accent = Color(0xFFFF9B2F);
  static const Color accentDeep = Color(0xFFFF7A1A);
  static const Color pink = Color(0xFFE23D6B);
  static const Color coral = Color(0xFFFF6B4A);
  static const Color marigold = Color(0xFFFFC53D);
  static const Color teal = Color(0xFF2BBBAD);
  static const Color sky = Color(0xFF4EA3F0);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightMuted = Color(0xFF5C6578);
  static const Color lightLine = Color(0xFFE8E8E8);

  static const Color darkSurface = Color(0xFF1A2436);
  static const Color darkMuted = Color(0xFFB8B3AB);
  static const Color darkLine = Color(0xFF2C3850);

  static const LinearGradient cta = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[accent, accentDeep],
  );

  static const LinearGradient ctaSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFFFB765), accentDeep],
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
    required this.accentSoft,
  });

  final Color success;
  final Color warning;
  final Color cardShadow;
  final Color imageFill;
  final Color chipFill;

  /// Tinted accent used behind chips, badges and icon buttons.
  final Color accentSoft;

  static const RangBazaarColors light = RangBazaarColors(
    success: Color(0xFF1F8A70),
    warning: AppColors.marigold,
    cardShadow: Color(0x14000000),
    imageFill: Color(0xFFF3F3F3),
    chipFill: Color(0xFFF6F6F6),
    accentSoft: Color(0xFFFFF1E2),
  );

  static const RangBazaarColors dark = RangBazaarColors(
    success: Color(0xFF4ECDC4),
    warning: AppColors.marigold,
    cardShadow: Color(0x33000000),
    imageFill: Color(0xFF222C40),
    chipFill: Color(0xFF243049),
    accentSoft: Color(0xFF3A2C1E),
  );

  @override
  RangBazaarColors copyWith({
    Color? success,
    Color? warning,
    Color? cardShadow,
    Color? imageFill,
    Color? chipFill,
    Color? accentSoft,
  }) {
    return RangBazaarColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      cardShadow: cardShadow ?? this.cardShadow,
      imageFill: imageFill ?? this.imageFill,
      chipFill: chipFill ?? this.chipFill,
      accentSoft: accentSoft ?? this.accentSoft,
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
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
    );
  }
}

extension RangBazaarColorsX on BuildContext {
  RangBazaarColors get rangColors =>
      Theme.of(this).extension<RangBazaarColors>() ?? RangBazaarColors.light;
}
