import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/category_style.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../domain/models/product.dart';

enum DetailTab { description, specifications, reviews }

class DetailTabBar extends StatelessWidget {
  const DetailTabBar({super.key, required this.current, required this.onTab});

  final DetailTab current;
  final ValueChanged<DetailTab> onTab;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _TabChip(
          label: AppStrings.description,
          selected: current == DetailTab.description,
          onTap: () => onTab(DetailTab.description),
        ),
        const SizedBox(width: AppSpacing.xs),
        _TabChip(
          label: AppStrings.specifications,
          selected: current == DetailTab.specifications,
          onTap: () => onTab(DetailTab.specifications),
        ),
        const SizedBox(width: AppSpacing.xs),
        _TabChip(
          label: AppStrings.reviewsTab,
          selected: current == DetailTab.reviews,
          onTap: () => onTab(DetailTab.reviews),
        ),
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: PressScale(
        onTap: onTap,
        scale: 0.94,
        semanticLabel: label,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.cta : null,
            color: selected ? null : context.rangColors.chipFill,
            borderRadius: AppRadius.pillAll,
            boxShadow: selected
                ? AppShadows.cta(AppColors.accent.withValues(alpha: 0.3))
                : null,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class DetailTabView extends StatelessWidget {
  const DetailTabView({super.key, required this.tab, required this.product});

  final DetailTab tab;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(
          key: ValueKey<DetailTab>(tab),
          child: switch (tab) {
            DetailTab.description => Text(
              product.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            DetailTab.specifications => _Specifications(product: product),
            DetailTab.reviews => _Reviews(product: product),
          },
        ),
      ),
    );
  }
}

class _Specifications extends StatelessWidget {
  const _Specifications({required this.product});

  final Product product;

  /// Catalogue copy the Fake Store API does not provide, keyed by category so
  /// a shirt does not advertise battery life.
  List<(String, String)> _categorySpecs() {
    return switch (product.category) {
      "men's clothing" || "women's clothing" => const <(String, String)>[
        ('Material', 'Cotton blend, pre-shrunk'),
        ('Fit', 'Regular fit'),
        ('Care', 'Machine wash cold, tumble dry low'),
      ],
      'jewelery' => const <(String, String)>[
        ('Material', 'Rhodium plated brass'),
        ('Finish', 'High polish'),
        ('Care', 'Keep away from moisture and perfume'),
      ],
      'electronics' => const <(String, String)>[
        ('Warranty', '1 year manufacturer warranty'),
        ('In the box', 'Device, cable, quick start guide'),
        ('Support', 'Email and phone, 9am to 9pm IST'),
      ],
      _ => const <(String, String)>[
        ('Quality', 'Checked before dispatch'),
        ('Packaging', 'Recyclable, plastic free'),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final List<(String, String)> rows = <(String, String)>[
      (AppStrings.specCategory, CategoryStyle.of(product.category).displayName),
      (AppStrings.sellerLabel, AppStrings.sellerName),
      (AppStrings.specSku, 'RB-${product.id.toString().padLeft(4, '0')}'),
      (AppStrings.specAvailability, AppStrings.inStock),
      ..._categorySpecs(),
      (AppStrings.specDelivery, AppStrings.specDeliveryValue),
      (AppStrings.specReturns, AppStrings.specReturnsValue),
      (AppStrings.specPayment, AppStrings.specPaymentValue),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.rangColors.chipFill,
        borderRadius: AppRadius.tile,
      ),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < rows.length; i++) ...<Widget>[
            if (i > 0) const Divider(height: 1),
            _SpecRow(label: rows[i].$1, value: rows[i].$2),
          ],
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Reviews extends StatelessWidget {
  const _Reviews({required this.product});

  final Product product;

  /// Spreads the review count across stars around the real average so the
  /// histogram matches the headline rating.
  List<int> _histogram() {
    final double rate = product.rating.rate;
    final List<double> weights = <double>[
      for (int star = 1; star <= 5; star++)
        math.exp(-math.pow(star - rate, 2) / 0.9),
    ];
    final double sum = weights.fold(0, (double a, double b) => a + b);
    return <int>[
      for (final double w in weights)
        ((w / sum) * product.rating.count).round(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final Color muted = theme.colorScheme.onSurfaceVariant;
    final List<int> histogram = _histogram();
    final int peak = histogram.reduce(math.max).clamp(1, 1 << 30);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.rating.rate.toStringAsFixed(1),
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentDeep,
                  ),
                ),
                Text(
                  AppStrings.ratingOutOf,
                  style: textTheme.bodySmall?.copyWith(color: muted),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${AppStrings.basedOnReviews} ${product.rating.count}',
                  style: textTheme.bodySmall?.copyWith(color: muted),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                children: <Widget>[
                  for (int star = 5; star >= 1; star--)
                    _HistogramRow(
                      star: star,
                      value: histogram[star - 1],
                      peak: peak,
                    ),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Divider(height: 1),
        ),
        for (int i = 0; i < _demoReviews.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          _ReviewCard(review: _demoReviews[i]),
        ],
      ],
    );
  }
}

class _HistogramRow extends StatelessWidget {
  const _HistogramRow({
    required this.star,
    required this.value,
    required this.peak,
  });

  final int star;
  final int value;
  final int peak;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Text('$star', style: theme.textTheme.bodySmall),
          const SizedBox(width: 2),
          const Icon(Icons.star_rounded, size: 12, color: AppColors.marigold),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: ClipRRect(
              borderRadius: AppRadius.pillAll,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: value / peak),
                duration: const Duration(milliseconds: 520),
                curve: Curves.easeOutCubic,
                builder: (BuildContext context, double factor, Widget? child) {
                  return LinearProgressIndicator(
                    value: factor,
                    minHeight: 6,
                    backgroundColor: theme.colorScheme.outline,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.accent,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          SizedBox(
            width: 30,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final _DemoReview review;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final Color muted = theme.colorScheme.onSurfaceVariant;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.rangColors.accentSoft,
            shape: BoxShape.circle,
          ),
          child: Text(
            review.initials,
            style: textTheme.labelLarge?.copyWith(
              color: AppColors.accentDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      review.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    review.when,
                    style: textTheme.bodySmall?.copyWith(color: muted),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: <Widget>[
                  for (int star = 1; star <= 5; star++)
                    Icon(
                      star <= review.stars
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 13,
                      color: star <= review.stars
                          ? AppColors.marigold
                          : theme.colorScheme.outline,
                    ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      AppStrings.verifiedBuyer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: context.rangColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                review.body,
                style: textTheme.bodyMedium?.copyWith(color: muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DemoReview {
  const _DemoReview({
    required this.initials,
    required this.name,
    required this.when,
    required this.stars,
    required this.body,
  });

  final String initials;
  final String name;
  final String when;
  final int stars;
  final String body;
}

const List<_DemoReview> _demoReviews = <_DemoReview>[
  _DemoReview(
    initials: 'AI',
    name: 'Ananya Iyer',
    when: '2 weeks ago',
    stars: 5,
    body:
        'Better quality than I expected for the price. Packaging was neat and '
        'it arrived two days early.',
  ),
  _DemoReview(
    initials: 'RM',
    name: 'Rohit Menon',
    when: '1 month ago',
    stars: 4,
    body:
        'Looks exactly like the photos. Took off a star only because I wish '
        'there were more colour options.',
  ),
  _DemoReview(
    initials: 'SK',
    name: 'Sneha Kulkarni',
    when: '2 months ago',
    stars: 5,
    body: 'Second time ordering from RangBazaar and the finish is consistent.',
  ),
];
