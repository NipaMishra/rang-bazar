import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/settings/presentation/providers/theme_controller.dart';
import '../../features/wishlist/presentation/providers/wishlist_provider.dart';
import '../constants/app_strings.dart';
import '../router/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';
import 'brand_logo.dart';
import 'press_scale.dart';

class ShopDrawer extends ConsumerWidget {
  const ShopDrawer({super.key});

  void _go(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.go(route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme scheme = theme.colorScheme;
    final bool isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final int cartCount = ref.watch(cartItemCountProvider);
    final int savedCount = ref.watch(wishlistProvider).length;
    final String path = GoRouterState.of(context).uri.path;

    return Drawer(
      width: 316,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.xs,
                0,
              ),
              child: Row(
                children: <Widget>[
                  const BrandLogo(height: 40),
                  const Spacer(),
                  IconButton(
                    tooltip: MaterialLocalizations.of(context)
                        .closeButtonTooltip,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: PressScale(
                onTap: () => _go(context, AppRoutes.profile),
                scale: 0.98,
                semanticLabel: AppStrings.profileView,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.card,
                    gradient: AppColors.cta,
                    boxShadow: AppShadows.cta(
                      AppColors.accent.withValues(alpha: 0.32),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'AS',
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.accentDeep,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppStrings.profileName,
                              style: textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              AppStrings.profileEmail,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppStrings.profileView,
                              style: textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const _SectionLabel(label: AppStrings.drawerShop),
            _DrawerTile(
              icon: Icons.home_outlined,
              label: AppStrings.navHome,
              selected: path == AppRoutes.home,
              onTap: () => _go(context, AppRoutes.home),
            ),
            _DrawerTile(
              icon: Icons.shopping_bag_outlined,
              label: AppStrings.cartTitle,
              badge: cartCount,
              selected: path == AppRoutes.cart,
              onTap: () => _go(context, AppRoutes.cart),
            ),
            _DrawerTile(
              icon: Icons.favorite_outline_rounded,
              label: AppStrings.favouritesTitle,
              badge: savedCount,
              selected: path == AppRoutes.favorites,
              onTap: () => _go(context, AppRoutes.favorites),
            ),
            _DrawerTile(
              icon: Icons.person_outline_rounded,
              label: AppStrings.navProfile,
              selected: path == AppRoutes.profile,
              onTap: () => _go(context, AppRoutes.profile),
            ),
            const SizedBox(height: AppSpacing.xs),
            const _SectionLabel(label: AppStrings.drawerPrefs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.card,
                ),
                secondary: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: context.rangColors.accentSoft,
                    borderRadius: AppRadius.tile,
                  ),
                  child: Icon(
                    isDark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_outlined,
                    size: 19,
                    color: AppColors.accentDeep,
                  ),
                ),
                title: Text(
                  AppStrings.themeDark,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: isDark,
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.accentDeep,
                onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: <Widget>[
                  AppButton(
                    label: AppStrings.signOut,
                    icon: Icons.logout_rounded,
                    variant: AppButtonVariant.tonal,
                    height: 48,
                    onPressed: () => _go(context, AppRoutes.login),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppStrings.tagline,
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.badge = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final Color ink = selected
        ? AppColors.accentDeep
        : Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      child: PressScale(
        onTap: onTap,
        scale: 0.97,
        semanticLabel: label,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected
                ? context.rangColors.accentSoft
                : Colors.transparent,
            borderRadius: AppRadius.card,
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, color: ink, size: 21),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: ink,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (badge > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.accentDeep,
                    borderRadius: AppRadius.pillAll,
                  ),
                  child: Text(
                    '$badge',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
