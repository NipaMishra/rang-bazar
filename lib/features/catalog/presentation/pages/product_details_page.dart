import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/error_message.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/color_dots.dart';
import '../../../../core/widgets/feedback_views.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../../../core/widgets/soft_icon_button.dart';
import '../../../../core/widgets/wishlist_button.dart';
import '../../../cart/domain/cart_item.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/models/product.dart';
import '../providers/catalog_providers.dart';
import '../widgets/detail_tabs.dart';

class ProductDetailsPage extends ConsumerWidget {
  const ProductDetailsPage({super.key, required this.productId});

  final int? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (productId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product')),
        body: EmptyView(
          title: AppStrings.invalidProduct,
          message: 'Go back and pick another product.',
          icon: Icons.search_off_rounded,
          actionLabel: AppStrings.startShopping,
          onAction: () => context.go(AppRoutes.home),
        ),
      );
    }

    final int id = productId!;
    final AsyncValue<Product> product = ref.watch(productDetailsProvider(id));

    return product.when(
      loading: () => const Scaffold(body: _DetailsSkeleton()),
      error: (Object error, StackTrace stackTrace) => Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const _FloatingTopBar(),
              Expanded(
                child: ErrorView(
                  message: userFacingError(error),
                  onRetry: () => ref.invalidate(productDetailsProvider(id)),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (Product item) => _ProductDetailsBody(product: item),
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
  late int _quantity;
  int _colorIndex = 0;
  DetailTab _tab = DetailTab.description;
  late ScaffoldMessengerState _messenger;
  late GoRouter _router;

  Product get product => widget.product;

  @override
  void initState() {
    super.initState();
    _quantity = _cartQuantity(ref.read(cartProvider)) ?? 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The cart snackbar outlives this page, so keep handles that stay valid
    // once the details route is gone.
    _messenger = ScaffoldMessenger.of(context);
    _router = GoRouter.of(context);
  }

  CartItem? _cartItem(List<CartItem> items) {
    for (final CartItem item in items) {
      if (item.product.id == product.id) return item;
    }
    return null;
  }

  int? _cartQuantity(List<CartItem> items) => _cartItem(items)?.quantity;

  void _openCart() {
    // Never leave a stale "Added to cart" bar hanging over the cart screen.
    _messenger.hideCurrentSnackBar();
    _router.push(AppRoutes.cart);
  }

  void _onCartAction(CartItem? existing) {
    final CartController cart = ref.read(cartProvider.notifier);
    if (existing == null) {
      cart.add(product, quantity: _quantity);
      _snack(AppStrings.addedToCart);
      return;
    }
    if (existing.quantity == _quantity) {
      _openCart();
      return;
    }
    cart.setQuantity(product.id, _quantity);
    _snack(AppStrings.quantityUpdated);
  }

  void _snack(String message) {
    _messenger.hideCurrentSnackBar();
    final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> bar =
        _messenger.showSnackBar(
          SnackBar(
            duration: AppDurations.snackbar,
            content: Text(message),
            action: SnackBarAction(
              label: AppStrings.goToCart,
              onPressed: _openCart,
            ),
          ),
        );

    // The bar is meant to follow the shopper back to the previous page, but
    // leaving this route stalls its own dismiss timer, so back it up.
    bool closed = false;
    unawaited(bar.closed.then((SnackBarClosedReason _) => closed = true));
    Timer(AppDurations.snackbar + AppDurations.snackbarGrace, () {
      if (!closed) _messenger.hideCurrentSnackBar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CartItem? existing = _cartItem(ref.watch(cartProvider));
    final bool synced = existing != null && existing.quantity == _quantity;
    final String buttonLabel = existing == null
        ? AppStrings.addToCart
        : synced
        ? AppStrings.goToCart
        : '${AppStrings.updateCart} · $_quantity';

    return Scaffold(
      body: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double imageHeight = (constraints.maxHeight * 0.46).clamp(
                260.0,
                420.0,
              );
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: _Gallery(
                        product: product,
                        height: imageHeight,
                        selectedDot: _colorIndex,
                        onDot: (int index) =>
                            setState(() => _colorIndex = index),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: imageHeight - AppSpacing.lg,
                      ),
                      child: ConstrainedBox(
                        // Keeps the sheet covering the viewport even when the
                        // copy is short, so no scaffold gap shows through.
                        constraints: BoxConstraints(
                          minHeight:
                              constraints.maxHeight -
                              imageHeight +
                              AppSpacing.lg,
                        ),
                        child: _DetailsSheet(
                          product: product,
                          colorIndex: _colorIndex,
                          tab: _tab,
                          onColor: (int index) =>
                              setState(() => _colorIndex = index),
                          onTab: (DetailTab tab) => setState(() => _tab = tab),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _FloatingTopBar(productId: product.id),
          ),
        ],
      ),
      bottomNavigationBar: _ActionBar(
        quantity: _quantity,
        label: buttonLabel,
        icon: synced
            ? Icons.arrow_forward_rounded
            : Icons.shopping_bag_outlined,
        onIncrement: () => setState(() => _quantity += 1),
        onDecrement: () {
          if (_quantity <= 1) return;
          setState(() => _quantity -= 1);
        },
        onPressed: () => _onCartAction(existing),
      ),
    );
  }
}

class _FloatingTopBar extends StatelessWidget {
  const _FloatingTopBar({this.productId});

  final int? productId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: <Widget>[
            GlassIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                  return;
                }
                context.go(AppRoutes.home);
              },
            ),
            const Spacer(),
            GlassIconButton(
              icon: Icons.share_outlined,
              tooltip: AppStrings.shareTooltip,
              onPressed: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text(AppStrings.shareSoon)),
                  );
              },
            ),
            if (productId != null) ...<Widget>[
              const SizedBox(width: AppSpacing.xs),
              WishlistButton(productId: productId!, framed: true),
            ],
          ],
        ),
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({
    required this.product,
    required this.height,
    required this.selectedDot,
    required this.onDot,
  });

  final Product product;
  final double height;
  final int selectedDot;
  final ValueChanged<int> onDot;

  @override
  Widget build(BuildContext context) {
    final List<Color> swatches = ProductSwatches.of(product.id);
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(color: context.rangColors.imageFill),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.xxl,
                  AppSpacing.xxl,
                  AppSpacing.xl,
                ),
                child: Hero(
                  tag: 'product-image-${product.id}',
                  child: AppNetworkImage(
                    url: product.image,
                    borderRadius: AppRadius.image,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.xl + AppSpacing.xs,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(swatches.length, (int index) {
                  final bool active = index == selectedDot;
                  return PressScale(
                    onTap: () => onDot(index),
                    scale: 0.7,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 18 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.accentDeep
                            : Theme.of(context).colorScheme.onSurface
                                  .withValues(alpha: 0.24),
                        borderRadius: AppRadius.pillAll,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsSheet extends StatelessWidget {
  const _DetailsSheet({
    required this.product,
    required this.colorIndex,
    required this.tab,
    required this.onColor,
    required this.onTab,
  });

  final Product product;
  final int colorIndex;
  final DetailTab tab;
  final ValueChanged<int> onColor;
  final ValueChanged<DetailTab> onTab;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final Color muted = theme.colorScheme.onSurfaceVariant;
    final List<Color> swatches = ProductSwatches.of(product.id);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.sheetTop,
        boxShadow: AppShadows.card(context.rangColors.cardShadow),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.xxl + AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: AppRadius.pillAll,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeIn(
            child: Text(
              product.title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          PriceText(
            product.price,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.accentDeep,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              _RatingChip(rate: product.rating.rate),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '(${product.rating.count} ${AppStrings.reviewsCountLabel})',
                style: textTheme.bodySmall?.copyWith(color: muted),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  '${AppStrings.sellerLabel}: ${AppStrings.sellerName}',
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(color: muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppStrings.colorsLabel,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: List<Widget>.generate(swatches.length, (int index) {
              final bool selected = index == colorIndex;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: PressScale(
                  onTap: () => onColor(index),
                  scale: 0.85,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? AppColors.accentDeep
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: swatches[index],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          DetailTabBar(current: tab, onTab: onTab),
          const SizedBox(height: AppSpacing.md),
          DetailTabView(tab: tab, product: product),
        ],
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip({required this.rate});

  final double rate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppColors.cta,
        borderRadius: AppRadius.pillAll,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.star_rounded, size: 14, color: Colors.white),
            const SizedBox(width: 3),
            Text(
              rate.toStringAsFixed(1),
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.quantity,
    required this.label,
    required this.icon,
    required this.onIncrement,
    required this.onDecrement,
    required this.onPressed,
  });

  final int quantity;
  final String label;
  final IconData icon;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.sheetTop,
        boxShadow: AppShadows.card(context.rangColors.cardShadow),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Row(
            children: <Widget>[
              QuantitySelector(
                quantity: quantity,
                inverted: true,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: label,
                  icon: icon,
                  height: 52,
                  onPressed: onPressed,
                ),
              ),
            ],
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(flex: 4, child: ShimmerBox(borderRadius: 0)),
        Expanded(
          flex: 6,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.page),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ShimmerBox(height: 26, width: 220, borderRadius: 8),
                SizedBox(height: AppSpacing.sm),
                ShimmerBox(height: 26, width: 120, borderRadius: 8),
                SizedBox(height: AppSpacing.lg),
                ShimmerBox(height: 14, width: double.infinity, borderRadius: 6),
                SizedBox(height: AppSpacing.xs),
                ShimmerBox(height: 14, width: double.infinity, borderRadius: 6),
                SizedBox(height: AppSpacing.xs),
                ShimmerBox(height: 14, width: 180, borderRadius: 6),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
