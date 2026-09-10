import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'press_scale.dart';

enum AppButtonVariant { primary, tonal, outline }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expand = true,
    this.height = AppSpacing.buttonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool expand;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool enabled = !loading && onPressed != null;
    final bool isPrimary = variant == AppButtonVariant.primary;

    final Color ink = switch (variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.tonal => AppColors.accentDeep,
      AppButtonVariant.outline => scheme.onSurface,
    };

    final Widget content = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: loading
          ? SizedBox(
              key: const ValueKey<String>('loading'),
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: ink),
            )
          : Row(
              key: ValueKey<String>(label),
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: 20, color: ink),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: enabled ? ink : ink.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
    );

    return PressScale(
      onTap: enabled ? onPressed : null,
      scale: 0.97,
      semanticLabel: label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: expand ? double.infinity : null,
        height: height,
        padding: expand
            ? null
            : const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: AppRadius.pillAll,
          gradient: isPrimary && enabled ? AppColors.cta : null,
          color: switch (variant) {
            AppButtonVariant.primary =>
              enabled ? null : scheme.onSurface.withValues(alpha: 0.12),
            AppButtonVariant.tonal => context.rangColors.accentSoft,
            AppButtonVariant.outline => Colors.transparent,
          },
          border: variant == AppButtonVariant.outline
              ? Border.all(color: scheme.outline)
              : null,
          boxShadow: isPrimary && enabled
              ? AppShadows.cta(AppColors.accent.withValues(alpha: 0.34))
              : null,
        ),
        child: content,
      ),
    );
  }
}
