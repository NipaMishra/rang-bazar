import 'package:flutter/material.dart';

import '../../features/catalog/domain/models/product.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_network_image.dart';
import 'color_dots.dart';
import 'press_scale.dart';
import 'price_text.dart';
import 'wishlist_button.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return PressScale(
      onTap: onTap,
      semanticLabel: product.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.rangColors.imageFill,
                      borderRadius: AppRadius.card,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Hero(
                        tag: 'product-image-${product.id}',
                        child: AppNetworkImage(
                          url: product.image,
                          borderRadius: AppRadius.image,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: WishlistButton(productId: product.id),
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: _RatingPill(rate: product.rating.rate),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Row(
            children: <Widget>[
              Expanded(
                child: PriceText(
                  product.price,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ColorDots.forProduct(product.id),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rate});

  final double rate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: AppRadius.pillAll,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.star_rounded, size: 13, color: AppColors.accent),
            const SizedBox(width: 3),
            Text(
              rate.toStringAsFixed(1),
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
