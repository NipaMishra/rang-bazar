import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/category_style.dart';
import 'press_scale.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  factory CategoryChip.all({
    required bool selected,
    required VoidCallback onTap,
  }) {
    return CategoryChip(
      label: AppStrings.allCategories,
      icon: Icons.apps_rounded,
      selected: selected,
      onTap: onTap,
    );
  }

  factory CategoryChip.fromSlug({
    required String slug,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final CategoryStyle style = CategoryStyle.of(slug);
    return CategoryChip(
      label: style.displayName.split(' ').first,
      icon: style.icon,
      selected: selected,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color ink = selected ? AppColors.accentDeep : scheme.onSurface;

    return Semantics(
      selected: selected,
      child: PressScale(
        onTap: onTap,
        scale: 0.92,
        semanticLabel: label,
        child: SizedBox(
          width: 68,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? context.rangColors.accentSoft
                      : context.rangColors.imageFill,
                  border: Border.all(
                    color: selected ? AppColors.accent : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: selected
                      ? AppShadows.cta(AppColors.accent.withValues(alpha: 0.28))
                      : null,
                ),
                child: Icon(icon, color: ink, size: 22),
              ),
              const SizedBox(height: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 240),
                style:
                    Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: ink,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ) ??
                    const TextStyle(),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
