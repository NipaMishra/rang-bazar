import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'press_scale.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.inverted = false,
    this.compact = false,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  /// Dark filled pill used on the product details action bar.
  final bool inverted;

  /// Small bordered pill used inside cart rows.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fill = inverted
        ? (isDark ? AppColors.darkLine : AppColors.navy)
        : compact
        ? Colors.transparent
        : context.rangColors.imageFill;
    final Color ink = inverted ? Colors.white : theme.colorScheme.onSurface;
    final double tap = compact ? 26 : 40;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: AppRadius.pillAll,
        border: compact ? Border.all(color: theme.colorScheme.outline) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _StepButton(
            icon: Icons.remove_rounded,
            size: tap,
            ink: ink,
            tooltip: 'Decrease quantity',
            onTap: onDecrement,
          ),
          SizedBox(
            width: compact ? 20 : 28,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Text(
                '$quantity',
                key: ValueKey<int>(quantity),
                textAlign: TextAlign.center,
                style:
                    (compact
                            ? theme.textTheme.labelLarge
                            : theme.textTheme.titleMedium)
                        ?.copyWith(color: ink, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            size: tap,
            ink: ink,
            tooltip: 'Increase quantity',
            onTap: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.size,
    required this.ink,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final double size;
  final Color ink;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: PressScale(
        onTap: onTap,
        scale: 0.82,
        semanticLabel: tooltip,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Icon(icon, size: size < 30 ? 15 : 19, color: ink),
          ),
        ),
      ),
    );
  }
}
