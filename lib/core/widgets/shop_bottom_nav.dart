import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/providers/cart_provider.dart';
import '../constants/app_strings.dart';
import '../router/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'press_scale.dart';

enum ShopTab { home, cart, favorites, profile }

class ShopBottomNav extends ConsumerWidget {
  const ShopBottomNav({
    super.key,
    required this.current,
    this.roundedTop = true,
  });

  final ShopTab current;

  /// Flattened when another pinned panel already caps the bottom area.
  final bool roundedTop;

  void _open(BuildContext context, ShopTab tab) {
    if (tab == current) return;
    context.go(switch (tab) {
      ShopTab.home => AppRoutes.home,
      ShopTab.cart => AppRoutes.cart,
      ShopTab.favorites => AppRoutes.favorites,
      ShopTab.profile => AppRoutes.profile,
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final int cartCount = ref.watch(cartItemCountProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: roundedTop ? AppRadius.sheetTop : null,
        boxShadow: roundedTop
            ? AppShadows.card(context.rangColors.cardShadow)
            : null,
        border: Border(top: BorderSide(color: scheme.outline)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppSpacing.navBarHeight,
          child: Row(
            children: <Widget>[
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: AppStrings.navHome,
                selected: current == ShopTab.home,
                onTap: () => _open(context, ShopTab.home),
              ),
              _NavItem(
                icon: Icons.shopping_bag_outlined,
                activeIcon: Icons.shopping_bag_rounded,
                label: AppStrings.cartTooltip,
                selected: current == ShopTab.cart,
                badgeCount: cartCount,
                onTap: () => _open(context, ShopTab.cart),
              ),
              _NavItem(
                icon: Icons.favorite_outline_rounded,
                activeIcon: Icons.favorite_rounded,
                label: AppStrings.navFavourites,
                selected: current == ShopTab.favorites,
                onTap: () => _open(context, ShopTab.favorites),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: AppStrings.navProfile,
                selected: current == ShopTab.profile,
                onTap: () => _open(context, ShopTab.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color ink = selected ? AppColors.accentDeep : scheme.onSurfaceVariant;

    return Expanded(
      child: Tooltip(
        message: label,
        child: PressScale(
          onTap: onTap,
          scale: 0.88,
          semanticLabel: label,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  AnimatedScale(
                    scale: selected ? 1.1 : 1,
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutBack,
                    child: Icon(
                      selected ? activeIcon : icon,
                      size: 24,
                      color: ink,
                    ),
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      right: -7,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        constraints: const BoxConstraints(minWidth: 17),
                        decoration: BoxDecoration(
                          color: AppColors.accentDeep,
                          borderRadius: AppRadius.pillAll,
                          border: Border.all(color: scheme.surface, width: 1.5),
                        ),
                        child: Text(
                          '$badgeCount',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                height: 1.3,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                height: 5,
                width: selected ? 5 : 0,
                decoration: const BoxDecoration(
                  color: AppColors.accentDeep,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
