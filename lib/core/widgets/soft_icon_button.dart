import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'press_scale.dart';

/// Rounded-square icon button used across headers and toolbars.
class SoftIconButton extends StatelessWidget {
  const SoftIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = 46,
    this.accented = false,
    this.badgeCount,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final double size;
  final bool accented;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Widget button = PressScale(
      onTap: onPressed,
      scale: 0.9,
      semanticLabel: tooltip,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: accented
              ? context.rangColors.accentSoft
              : context.rangColors.chipFill,
          borderRadius: AppRadius.tile,
          border: Border.all(color: scheme.outline.withValues(alpha: 0.6)),
        ),
        child: Icon(
          icon,
          size: 21,
          color: accented ? AppColors.accentDeep : scheme.onSurface,
        ),
      ),
    );

    // App bars hand their leading/actions tight constraints, so keep the
    // square from stretching with the toolbar height.
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: Tooltip(
        message: tooltip,
        child: badgeCount == null || badgeCount == 0
            ? button
            : Badge.count(
                count: badgeCount!,
                backgroundColor: AppColors.accentDeep,
                textColor: Colors.white,
                offset: const Offset(-2, 2),
                child: button,
              ),
      ),
    );
  }
}

/// Circular translucent button that floats over imagery (product gallery).
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = 42,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final double size;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: PressScale(
        onTap: onPressed,
        scale: 0.9,
        semanticLabel: tooltip,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.88),
            shape: BoxShape.circle,
            boxShadow: AppShadows.soft(context.rangColors.cardShadow),
          ),
          child: Icon(icon, size: 19, color: iconColor ?? scheme.onSurface),
        ),
      ),
    );
  }
}
