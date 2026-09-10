import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../domain/cart_item.dart';
import '../providers/cart_provider.dart';

/// Snackbar-styled strap that stays pinned above the tab bar while the cart
/// has something in it, so the shortcut is always one tap away.
class CartStrap extends ConsumerWidget {
  const CartStrap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CartItem> items = ref.watch(cartProvider);
    final ThemeData theme = Theme.of(context);

    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      alignment: Alignment.bottomCenter,
      child: items.isEmpty
          ? const SizedBox(width: double.infinity)
          : _Strap(items: items, theme: theme),
    );
  }
}

class _Strap extends StatelessWidget {
  const _Strap({required this.items, required this.theme});

  final List<CartItem> items;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final int units = items.fold<int>(
      0,
      (int sum, CartItem item) => sum + item.quantity,
    );
    final double subtotal = items.fold<double>(
      0,
      (double sum, CartItem item) => sum + item.lineTotal,
    );
    final Color surface = theme.colorScheme.surface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: PressScale(
        onTap: () => context.push(AppRoutes.cart),
        scale: 0.98,
        semanticLabel: AppStrings.goToCart,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface,
            borderRadius: AppRadius.field,
            boxShadow: AppShadows.card(context.rangColors.cardShadow),
          ),
          child: Row(
            children: <Widget>[
              Icon(Icons.shopping_bag_outlined, size: 20, color: surface),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '${AppStrings.itemCount(units)} · '
                  '${PriceFormatter.format(subtotal)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(color: surface),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                AppStrings.goToCart,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
