import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/providers/cart_provider.dart';
import '../constants/app_strings.dart';
import '../router/app_routes.dart';
import 'app_button.dart';

class CartIconButton extends ConsumerWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int count = ref.watch(cartItemCountProvider);
    return CircleIconButton(
      tooltip: AppStrings.cartTooltip,
      onPressed: () => context.push(AppRoutes.cart),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
