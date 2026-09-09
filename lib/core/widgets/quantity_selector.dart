import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

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
  final bool inverted;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color fill = inverted
        ? (isDark ? AppColors.darkLine : AppColors.navy)
        : compact
        ? Colors.transparent
        : (isDark ? AppColors.darkLine : const Color(0xFFF3F3F3));
    final Color ink = inverted
        ? Colors.white
        : Theme.of(context).iconTheme.color!;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: AppRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            visualDensity: VisualDensity.compact,
            constraints: compact
                ? const BoxConstraints.tightFor(width: 28, height: 28)
                : null,
            padding: compact ? EdgeInsets.zero : null,
            tooltip: 'Decrease quantity',
            onPressed: onDecrement,
            icon: Icon(Icons.remove_rounded, size: compact ? 16 : 18, color: ink),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              '$quantity',
              key: ValueKey<int>(quantity),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: inverted ? Colors.white : null,
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            constraints: compact
                ? const BoxConstraints.tightFor(width: 28, height: 28)
                : null,
            padding: compact ? EdgeInsets.zero : null,
            tooltip: 'Increase quantity',
            onPressed: onIncrement,
            icon: Icon(Icons.add_rounded, size: compact ? 16 : 18, color: ink),
          ),
        ],
      ),
    );
  }
}
