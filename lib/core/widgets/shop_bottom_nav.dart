import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/providers/cart_provider.dart';
import '../constants/app_strings.dart';
import '../router/app_routes.dart';

enum ShopTab { home, cart, favorites, profile }

class ShopBottomNav extends ConsumerWidget {
  const ShopBottomNav({super.key, required this.current});

  final ShopTab current;

  int get _selectedIndex => switch (current) {
    ShopTab.home => 0,
    ShopTab.cart => 1,
    ShopTab.favorites => 2,
    ShopTab.profile => 3,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int cartCount = ref.watch(cartItemCountProvider);
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        switch (index) {
          case 0:
            if (current != ShopTab.home) context.go(AppRoutes.home);
          case 1:
            if (current != ShopTab.cart) context.go(AppRoutes.cart);
          case 2:
            if (current != ShopTab.favorites) context.go(AppRoutes.favorites);
          case 3:
            if (current != ShopTab.profile) context.go(AppRoutes.profile);
        }
      },
      destinations: <Widget>[
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: AppStrings.navHome,
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text('$cartCount'),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
          selectedIcon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text('$cartCount'),
            child: const Icon(Icons.shopping_bag_rounded),
          ),
          label: AppStrings.cartTooltip,
        ),
        const NavigationDestination(
          icon: Icon(Icons.favorite_outline_rounded),
          selectedIcon: Icon(Icons.favorite_rounded),
          label: AppStrings.navFavourites,
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: AppStrings.navProfile,
        ),
      ],
    );
  }
}
