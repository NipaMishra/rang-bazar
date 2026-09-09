import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rate, required this.count});

  final double rate;
  final int count;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.star_rounded, size: 18, color: AppColors.marigold),
        const SizedBox(width: AppSpacing.xxs),
        Text(rate.toStringAsFixed(1), style: textTheme.labelLarge),
        const SizedBox(width: AppSpacing.xxs),
        Text('($count)', style: textTheme.bodySmall),
      ],
    );
  }
}
