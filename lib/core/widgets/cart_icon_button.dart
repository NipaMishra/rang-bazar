import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/providers/cart_provider.dart';
import '../constants/app_strings.dart';
import '../router/app_routes.dart';
import '../theme/app_spacing.dart';
import 'soft_icon_button.dart';

class CartIconButton extends ConsumerWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int count = ref.watch(cartItemCountProvider);
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: SoftIconButton(
        icon: Icons.shopping_bag_outlined,
        tooltip: AppStrings.cartTooltip,
        badgeCount: count,
        onPressed: () => context.push(AppRoutes.cart),
      ),
    );
  }
}
