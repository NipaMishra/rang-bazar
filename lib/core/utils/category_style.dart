import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CategoryStyle {
  const CategoryStyle({
    required this.displayName,
    required this.icon,
    required this.accent,
  });

  final String displayName;
  final IconData icon;
  final Color accent;

  static CategoryStyle of(String slug) {
    switch (slug.toLowerCase().trim()) {
      case 'electronics':
        return const CategoryStyle(
          displayName: 'Electronics',
          icon: Icons.devices_other_rounded,
          accent: AppColors.sky,
        );
      case 'jewelery':
      case 'jewelry':
        return const CategoryStyle(
          displayName: 'Jewellery',
          icon: Icons.diamond_outlined,
          accent: AppColors.marigold,
        );
      case "men's clothing":
        return const CategoryStyle(
          displayName: "Men's Clothing",
          icon: Icons.man_2_outlined,
          accent: AppColors.teal,
        );
      case "women's clothing":
        return const CategoryStyle(
          displayName: "Women's Clothing",
          icon: Icons.woman_2_outlined,
          accent: AppColors.pink,
        );
      default:
        return CategoryStyle(
          displayName: _titleCase(slug),
          icon: Icons.category_outlined,
          accent: AppColors.coral,
        );
    }
  }

  static String _titleCase(String value) {
    return value
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .map(
          (String part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
