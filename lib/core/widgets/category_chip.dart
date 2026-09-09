import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/category_style.dart';

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
    final Color ring = selected ? AppColors.accent : Colors.transparent;
    final Color fill = context.rangColors.imageFill;
    final Color ink = selected
        ? AppColors.accent
        : Theme.of(context).colorScheme.onSurface;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: SizedBox(
          width: 68,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: fill,
                  border: Border.all(color: ring, width: 2),
                ),
                child: Icon(icon, color: ink, size: 22),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: ink,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
