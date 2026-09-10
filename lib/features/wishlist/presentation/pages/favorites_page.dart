import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/error_message.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/catalog_cards.dart';
import '../../../../core/widgets/feedback_views.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../../../core/widgets/shop_bottom_nav.dart';
import '../../../../core/widgets/shop_scaffold.dart';
import '../../../../core/widgets/soft_icon_button.dart';
import '../../../catalog/domain/models/product.dart';
import '../../../catalog/presentation/providers/catalog_providers.dart';
import '../providers/wishlist_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Set<int> saved = ref.watch(wishlistProvider);
    final AsyncValue<List<Product>> products = ref.watch(allProductsProvider);

    return ShopScaffold(
      current: ShopTab.favorites,
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
        title: const Text(AppStrings.favouritesTitle),
        actions: <Widget>[
          if (saved.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.page),
              child: Center(
                child: Text(
                  AppStrings.itemCount(saved.length),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: products.when(
        loading: () => const ProductGridSkeleton(columns: 2),
        error: (Object error, StackTrace stackTrace) => ErrorView(
          message: userFacingError(error),
          onRetry: () => ref.invalidate(allProductsProvider),
        ),
        data: (List<Product> items) {
          final List<Product> visible = items
              .where((Product product) => saved.contains(product.id))
              .toList(growable: false);
          if (visible.isEmpty) {
            return EmptyView(
              title: AppStrings.favouritesEmptyTitle,
              message: AppStrings.favouritesEmptyMessage,
              icon: Icons.favorite_outline_rounded,
              actionLabel: AppStrings.startShopping,
              onAction: () => context.go(AppRoutes.home),
            );
          }
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int columns = AppBreakpoints.productColumns(
                constraints.maxWidth,
              );
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.xs,
                  AppSpacing.page,
                  AppSpacing.lg,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.72,
                ),
                itemCount: visible.length,
                itemBuilder: (BuildContext context, int index) {
                  final Product product = visible[index];
                  return AppFadeIn.staggered(
                    index: index,
                    child: ProductCard(
                      product: product,
                      onTap: () =>
                          context.push(AppRoutes.productDetails(product.id)),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
