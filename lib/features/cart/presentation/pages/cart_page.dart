import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/category_style.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/feedback_views.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../../core/widgets/shop_bottom_nav.dart';
import '../../../../core/widgets/shop_scaffold.dart';
import '../../domain/cart_item.dart';
import '../providers/cart_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CartItem> items = ref.watch(cartProvider);
    final CartController cart = ref.read(cartProvider.notifier);

    return ShopScaffold(
      current: ShopTab.cart,
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutes.home);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        title: const Text(AppStrings.cartTitle),
      ),
      body: items.isEmpty
          ? EmptyView(
              title: AppStrings.cartEmptyTitle,
              message: AppStrings.cartEmptyMessage,
              actionLabel: AppStrings.startShopping,
              onAction: () => context.go(AppRoutes.home),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.page),
                    itemCount: items.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int index) {
                      final CartItem item = items[index];
                      return _CartTile(
                        item: item,
                        onIncrement: () => cart.increment(item.product.id),
                        onDecrement: () => cart.decrement(item.product.id),
                        onRemove: () => cart.remove(item.product.id),
                      );
                    },
                  ),
                ),
                _CartSummary(
                  subtotal: items.fold<double>(
                    0,
                    (double sum, CartItem item) => sum + item.lineTotal,
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartTile extends StatelessWidget {
  const _CartTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String category = CategoryStyle.of(item.product.category).displayName;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.soft(context.rangColors.cardShadow),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 64,
              height: 64,
              child: AppNetworkImage(url: item.product.image),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      PriceText(
                        item.product.price,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      QuantitySelector(
                        quantity: item.quantity,
                        compact: true,
                        onIncrement: onIncrement,
                        onDecrement: onDecrement,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: AppStrings.removeItem,
              onPressed: onRemove,
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSummary extends StatefulWidget {
  const _CartSummary({required this.subtotal});

  final double subtotal;

  @override
  State<_CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<_CartSummary> {
  final TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
        boxShadow: AppShadows.soft(context.rangColors.cardShadow),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.lg,
            AppSpacing.page,
            AppSpacing.md,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _code,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        hintText: AppStrings.discountHint,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(content: Text(AppStrings.discountSoon)),
                        );
                    },
                    child: Text(
                      AppStrings.apply,
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Text(AppStrings.subtotal, style: textTheme.titleMedium),
                  const Spacer(),
                  PriceText(widget.subtotal, style: textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: <Widget>[
                  Text(AppStrings.total, style: textTheme.titleLarge),
                  const Spacer(),
                  PriceText(
                    widget.subtotal,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: AppStrings.checkout,
                onPressed: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text(AppStrings.checkoutSoon)),
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
