import 'package:flutter/material.dart';

import '../../features/catalog/domain/models/product.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_network_image.dart';
import 'color_dots.dart';
import 'price_text.dart';
import 'wishlist_button.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: product.title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.card,
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
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Expanded(
                    child: PriceText(
                      product.price,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ColorDots.forProduct(product.id),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
