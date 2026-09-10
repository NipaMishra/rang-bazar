import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/price_text.dart';

/// Confirmation sheet shown after checkout. Call it before clearing the cart
/// so the totals it displays survive the state reset.
Future<void> showOrderPlacedSheet(
  BuildContext context, {
  required String orderId,
  required int units,
  required double total,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    builder: (BuildContext context) =>
        _OrderPlacedSheet(orderId: orderId, units: units, total: total),
  );
}

class _OrderPlacedSheet extends StatelessWidget {
  const _OrderPlacedSheet({
    required this.orderId,
    required this.units,
    required this.total,
  });

  final String orderId;
  final int units;
  final double total;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.md,
          AppSpacing.page,
          AppSpacing.page,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: AppRadius.pillAll,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const _SuccessBadge(),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppStrings.orderPlacedTitle,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppStrings.orderPlacedMessage,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: context.rangColors.chipFill,
                borderRadius: AppRadius.tile,
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Column(
                children: <Widget>[
                  _Row(
                    label: AppStrings.orderIdLabel,
                    value: Text(
                      orderId,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _Row(
                    label: AppStrings.orderItemsLabel,
                    value: Text(
                      AppStrings.itemCount(units),
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _Row(
                    label: AppStrings.orderArrivingLabel,
                    value: Text(
                      AppStrings.orderArrivingValue,
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
                  _Row(
                    label: AppStrings.orderPaidLabel,
                    value: PriceText(
                      total,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.accentDeep,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: AppStrings.continueShopping,
              icon: Icons.storefront_rounded,
              height: 52,
              onPressed: () {
                Navigator.of(context).pop();
                context.go(AppRoutes.home);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    final Color success = context.rangColors.success;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.elasticOut,
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: success.withValues(alpha: 0.14),
        ),
        child: Center(
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.cta,
              boxShadow: AppShadows.cta(
                AppColors.accent.withValues(alpha: 0.34),
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

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
