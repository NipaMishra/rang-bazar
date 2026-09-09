import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final bool enabled = !loading && onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.pillAll,
          gradient: enabled ? AppColors.cta : null,
          color: enabled
              ? null
              : Theme.of(context).disabledColor.withValues(alpha: 0.25),
          boxShadow: enabled
              ? AppShadows.cta(AppColors.coral.withValues(alpha: 0.38))
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: AppRadius.pillAll,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : icon == null
                  ? Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(color: Colors.white),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(icon, size: 20, color: Colors.white),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          label,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final Widget icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final Color fill = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkSurface
        : const Color(0xFFF3EEE8);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: fill,
        shape: const CircleBorder(),
        child: IconButton(tooltip: tooltip, onPressed: onPressed, icon: icon),
      ),
    );
  }
}
