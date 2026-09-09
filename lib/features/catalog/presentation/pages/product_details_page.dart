import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/category_style.dart';
import '../../../../core/utils/error_message.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/color_dots.dart';
import '../../../../core/widgets/feedback_views.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../../../core/widgets/wishlist_button.dart';
import '../../../cart/domain/cart_item.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/models/product.dart';
import '../providers/catalog_providers.dart';

enum _DetailTab { description, specifications, reviews }

class ProductDetailsPage extends ConsumerWidget {
  const ProductDetailsPage({super.key, required this.productId});

  final int? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (productId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product')),
        body: const EmptyView(
          title: AppStrings.invalidProduct,
          message: 'Go back and pick another product.',
          icon: Icons.search_off_rounded,
        ),
      );
    }

    final int id = productId!;
    final AsyncValue<Product> product = ref.watch(productDetailsProvider(id));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: AppStrings.shareTooltip,
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text(AppStrings.shareSoon)),
                );
            },
            icon: const Icon(Icons.share_outlined),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: WishlistButton(productId: id, framed: true),
          ),
        ],
      ),
      body: product.when(
        loading: () => const _DetailsSkeleton(),
        error: (Object error, StackTrace stackTrace) => ErrorView(
          message: userFacingError(error),
          onRetry: () => ref.invalidate(productDetailsProvider(id)),
        ),
        data: (Product item) => _ProductDetailsBody(product: item),
      ),
    );
  }
}

class _ProductDetailsBody extends ConsumerStatefulWidget {
  const _ProductDetailsBody({required this.product});

  final Product product;

  @override
  ConsumerState<_ProductDetailsBody> createState() =>
      _ProductDetailsBodyState();
}

class _ProductDetailsBodyState extends ConsumerState<_ProductDetailsBody> {
  int _quantity = 1;
  int _colorIndex = 0;
  _DetailTab _tab = _DetailTab.description;

  Product get product => widget.product;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Column(
      children: <Widget>[
        Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    AppSpacing.sm,
                    AppSpacing.page,
                    AppSpacing.md,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.05,
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
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.page,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.title,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                          PriceText(
                        product.price,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: <Widget>[
                          RatingStars(
                            rate: product.rating.rate,
                            count: product.rating.count,
                          ),
                          const Spacer(),
                          Text(
                            '${AppStrings.sellerLabel}: ${AppStrings.sellerName}',
                            style: textTheme.bodyMedium?.copyWith(color: muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(AppStrings.colorsLabel, style: textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: List<Widget>.generate(
                          ProductSwatches.of(product.id).length,
                          (int index) {
                            final bool selected = index == _colorIndex;
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.sm,
                              ),
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _colorIndex = index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ProductSwatches.of(
                                      product.id,
                                    )[index],
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.accent
                                          : Colors.transparent,
                                      width: 2.4,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: <Widget>[
                          _TabChip(
                            label: AppStrings.description,
                            selected: _tab == _DetailTab.description,
                            onTap: () => setState(
                              () => _tab = _DetailTab.description,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _TabChip(
                            label: AppStrings.specifications,
                            selected: _tab == _DetailTab.specifications,
                            onTap: () => setState(
                              () => _tab = _DetailTab.specifications,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _TabChip(
                            label: AppStrings.reviewsTab,
                            selected: _tab == _DetailTab.reviews,
                            onTap: () =>
                                setState(() => _tab = _DetailTab.reviews),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(_tabCopy(), style: textTheme.bodyLarge),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: AppShadows.soft(context.rangColors.cardShadow),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.md,
                AppSpacing.page,
                AppSpacing.md,
              ),
              child: Row(
                children: <Widget>[
                  QuantitySelector(
                    quantity: _quantity,
                    inverted: true,
                    onIncrement: () => setState(() => _quantity += 1),
                    onDecrement: () {
                      if (_quantity <= 1) return;
                      setState(() => _quantity -= 1);
                    },
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: AppStrings.addToCart,
                      onPressed: () {
                        final bool existed = ref
                            .read(cartProvider)
                            .any(
                              (CartItem item) =>
                                  item.product.id == product.id,
                            );
                        ref
                            .read(cartProvider.notifier)
                            .add(product, quantity: _quantity);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              duration: AppDurations.snackbar,
                              content: Text(
                                existed
                                    ? AppStrings.quantityUpdated
                                    : AppStrings.addedToCart,
                              ),
                            ),
                          );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _tabCopy() {
    final String category = CategoryStyle.of(product.category).displayName;
    return switch (_tab) {
      _DetailTab.description => product.description,
      _DetailTab.specifications =>
        '$category · ${product.rating.rate} ★ · ${product.rating.count} ${AppStrings.reviews}',
      _DetailTab.reviews =>
        'Rated ${product.rating.rate} from ${product.rating.count} shoppers.',
    };
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : Colors.transparent,
          borderRadius: AppRadius.pillAll,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _DetailsSkeleton extends StatelessWidget {
  const _DetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(aspectRatio: 1, child: ShimmerBox()),
          SizedBox(height: AppSpacing.md),
          ShimmerBox(height: 28, width: double.infinity, borderRadius: 8),
          SizedBox(height: AppSpacing.sm),
          ShimmerBox(height: 28, width: 160, borderRadius: 8),
        ],
      ),
    );
  }
}
