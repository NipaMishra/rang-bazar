import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/category_style.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/feedback_views.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../../core/widgets/shop_bottom_nav.dart';
import '../../../../core/widgets/shop_scaffold.dart';
import '../../../../core/widgets/soft_icon_button.dart';
import '../../domain/cart_item.dart';
import '../providers/cart_provider.dart';
import '../widgets/order_placed_sheet.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  void _remove(BuildContext context, WidgetRef ref, int index, CartItem item) {
    ref.read(cartProvider.notifier).remove(item.product.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: AppDurations.snackbar,
          content: const Text(AppStrings.itemRemoved),
          action: SnackBarAction(
            label: AppStrings.undo,
            onPressed: () =>
                ref.read(cartProvider.notifier).insertAt(index, item),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CartItem> items = ref.watch(cartProvider);
    final CartController cart = ref.read(cartProvider.notifier);
    final int units = items.fold<int>(
      0,
      (int sum, CartItem item) => sum + item.quantity,
    );

    return ShopScaffold(
      current: ShopTab.cart,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm),
          child: SoftIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            size: 42,
            onPressed: () {
              if (context.canPop()) {
                context.pop();
                return;
              }
              context.go(AppRoutes.home);
            },
          ),
        ),
        leadingWidth: 66,
        title: const Text(AppStrings.cartTitle),
        actions: <Widget>[
          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.page),
              child: Center(
                child: Text(
                  AppStrings.itemCount(units),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
      flushFooter: true,
      footer: items.isEmpty
          ? null
          : _CartSummary(
              subtotal: items.fold<double>(
                0,
                (double sum, CartItem item) => sum + item.lineTotal,
              ),
              units: units,
              onPlaced: cart.clear,
            ),
      body: items.isEmpty
          ? EmptyView(
              title: AppStrings.cartEmptyTitle,
              message: AppStrings.cartEmptyMessage,
              actionLabel: AppStrings.startShopping,
              onAction: () => context.go(AppRoutes.home),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.xs,
                AppSpacing.page,
                AppSpacing.md,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (BuildContext context, int index) {
                final CartItem item = items[index];
                return AppFadeIn.staggered(
                  index: index,
                  child: Dismissible(
                    key: ValueKey<int>(item.product.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _remove(context, ref, index, item),
                    background: const _DismissBackground(),
                    child: _CartTile(
                      item: item,
                      onIncrement: () => cart.increment(item.product.id),
                      onDecrement: () => cart.decrement(item.product.id),
                      onRemove: () => _remove(context, ref, index, item),
                      onTap: () => context.push(
                        AppRoutes.productDetails(item.product.id),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.cta,
        borderRadius: AppRadius.card,
      ),
      child: Padding(
        padding: EdgeInsets.only(right: AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete_outline_rounded, color: Colors.white),
            SizedBox(width: AppSpacing.xs),
            Text(
              AppStrings.removeItem,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
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
    required this.onTap,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final String category = CategoryStyle.of(item.product.category).displayName;

    return PressScale(
      onTap: onTap,
      scale: 0.98,
      semanticLabel: item.product.title,
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: AppRadius.card,
          boxShadow: AppShadows.card(context.rangColors.cardShadow),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.rangColors.imageFill,
                borderRadius: AppRadius.tile,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: SizedBox(
                  width: 62,
                  height: 62,
                  child: AppNetworkImage(
                    url: item.product.image,
                    borderRadius: AppRadius.tile,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          item.product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Tooltip(
                        message: AppStrings.removeItem,
                        child: PressScale(
                          onTap: onRemove,
                          scale: 0.8,
                          semanticLabel: AppStrings.removeItem,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6, bottom: 6),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              size: 19,
                              color: AppColors.accentDeep,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: <Widget>[
                      PriceText(
                        item.lineTotal,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
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
          ],
        ),
      ),
    );
  }
}

class _CartSummary extends StatefulWidget {
  const _CartSummary({
    required this.subtotal,
    required this.units,
    required this.onPlaced,
  });

  final double subtotal;
  final int units;
  final VoidCallback onPlaced;

  @override
  State<_CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<_CartSummary> {
  final TextEditingController _code = TextEditingController();
  bool _placing = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_placing) return;
    setState(() => _placing = true);
    await Future<void>.delayed(AppDurations.checkoutSimulate);
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final int orderNumber =
        DateTime.now().millisecondsSinceEpoch.remainder(900000) + 100000;
    // Push the sheet before emptying the cart: clearing disposes this widget.
    final Future<void> sheet = showOrderPlacedSheet(
      context,
      orderId: 'RB$orderNumber',
      units: widget.units,
      total: widget.subtotal,
    );
    widget.onPlaced();
    await sheet;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.sheetTop,
        boxShadow: AppShadows.card(context.rangColors.cardShadow),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.md,
          AppSpacing.page,
          AppSpacing.md,
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: AppSpacing.md, right: 6),
              decoration: BoxDecoration(
                color: context.rangColors.chipFill,
                borderRadius: AppRadius.pillAll,
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _code,
                      textInputAction: TextInputAction.done,
                      style: textTheme.bodyMedium,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 13,
                        ),
                        hintText: AppStrings.discountHint,
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  AppButton(
                    label: AppStrings.apply,
                    expand: false,
                    height: 38,
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(AppStrings.discountSoon),
                          ),
                        );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _SummaryRow(
              label: AppStrings.subtotal,
              value: PriceText(
                widget.subtotal,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            _SummaryRow(
              label: AppStrings.delivery,
              value: Text(
                AppStrings.deliveryFree,
                style: textTheme.titleSmall?.copyWith(
                  color: context.rangColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Divider(height: 1),
            ),
            Row(
              children: <Widget>[
                Text(
                  AppStrings.total,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: PriceText(
                    widget.subtotal,
                    key: ValueKey<double>(widget.subtotal),
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentDeep,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: AppStrings.checkout,
              icon: Icons.lock_outline_rounded,
              height: 52,
              loading: _placing,
              onPressed: _placeOrder,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const Spacer(),
        value,
      ],
    );
  }
}
