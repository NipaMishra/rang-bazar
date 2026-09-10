import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../core/widgets/shop_bottom_nav.dart';
import '../../../../core/widgets/shop_scaffold.dart';
import '../../../../core/widgets/soft_icon_button.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../settings/presentation/providers/theme_controller.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void _soon(BuildContext context, [String message = AppStrings.profileSoon]) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final int cartCount = ref.watch(cartItemCountProvider);
    final int savedCount = ref.watch(wishlistProvider).length;
    final bool isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return ShopScaffold(
      current: ShopTab.profile,
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
        title: const Text(AppStrings.profileTitle),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: SoftIconButton(
              icon: Icons.edit_outlined,
              tooltip: AppStrings.profileEdit,
              onPressed: () => _soon(context, AppStrings.profileEditSoon),
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.xs,
          AppSpacing.page,
          AppSpacing.lg,
        ),
        children: <Widget>[
          AppFadeIn(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppRadius.card,
                gradient: AppColors.cta,
                boxShadow: AppShadows.cta(
                  AppColors.accent.withValues(alpha: 0.32),
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 66,
                    height: 66,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'AS',
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.accentDeep,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppStrings.profileName,
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppStrings.profileEmail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.24),
                            borderRadius: AppRadius.pillAll,
                          ),
                          child: Text(
                            AppStrings.profileMemberSince,
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeIn(
            delay: const Duration(milliseconds: 80),
            child: Row(
              children: <Widget>[
                const _StatCard(
                  icon: Icons.receipt_long_outlined,
                  label: AppStrings.profileOrders,
                  value: '12',
                ),
                const SizedBox(width: AppSpacing.sm),
                _StatCard(
                  icon: Icons.favorite_outline_rounded,
                  label: AppStrings.profileWishlist,
                  value: '$savedCount',
                ),
                const SizedBox(width: AppSpacing.sm),
                _StatCard(
                  icon: Icons.shopping_bag_outlined,
                  label: AppStrings.profileBag,
                  value: '$cartCount',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const AppFadeIn(
            delay: Duration(milliseconds: 140),
            child: _Card(
              child: Column(
                children: <Widget>[
                  _InfoRow(
                    icon: Icons.mail_outline_rounded,
                    label: AppStrings.profileEmailLabel,
                    value: AppStrings.profileEmail,
                  ),
                  Divider(height: AppSpacing.lg),
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: AppStrings.profilePhoneLabel,
                    value: AppStrings.profilePhone,
                  ),
                  Divider(height: AppSpacing.lg),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: AppStrings.profileCityLabel,
                    value: AppStrings.profileCity,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeIn(
            delay: const Duration(milliseconds: 200),
            child: _Card(
              child: Column(
                children: <Widget>[
                  _ActionTile(
                    icon: Icons.local_shipping_outlined,
                    label: AppStrings.profileAddresses,
                    onTap: () => _soon(context),
                  ),
                  _ActionTile(
                    icon: Icons.credit_card_outlined,
                    label: AppStrings.profilePayments,
                    onTap: () => _soon(context),
                  ),
                  _ActionTile(
                    icon: Icons.receipt_long_outlined,
                    label: AppStrings.profileOrders,
                    onTap: () => _soon(context),
                  ),
                  _ActionTile(
                    icon: Icons.help_outline_rounded,
                    label: AppStrings.profileHelp,
                    onTap: () => _soon(context),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: _TileIcon(
                        icon: isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_outlined,
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
                      onChanged: (_) =>
                          ref.read(themeModeProvider.notifier).toggle(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: AppStrings.profileEdit,
            icon: Icons.edit_outlined,
            onPressed: () => _soon(context, AppStrings.profileEditSoon),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: AppStrings.signOut,
            icon: Icons.logout_rounded,
            variant: AppButtonVariant.outline,
            onPressed: () => context.go(AppRoutes.login),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.card(context.rangColors.cardShadow),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: child,
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: context.rangColors.accentSoft,
        borderRadius: AppRadius.tile,
      ),
      child: Icon(icon, size: 19, color: AppColors.accentDeep),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: AppRadius.card,
          boxShadow: AppShadows.card(context.rangColors.cardShadow),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 19, color: AppColors.accentDeep),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _TileIcon(icon: icon),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      scale: 0.98,
      semanticLabel: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: <Widget>[
            _TileIcon(icon: icon),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
