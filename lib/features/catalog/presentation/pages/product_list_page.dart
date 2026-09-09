import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/category_style.dart';
import '../../../../core/utils/error_message.dart';
import '../../../../core/widgets/cart_icon_button.dart';
import '../../../../core/widgets/catalog_cards.dart';
import '../../../../core/widgets/feedback_views.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../domain/models/product.dart';
import '../providers/catalog_providers.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key, required this.category});

  final String? category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (category == null || category!.trim().isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: ErrorView(
          message: AppStrings.invalidProduct,
          onRetry: () => context.go(AppRoutes.home),
        ),
      );
    }

    final String slug = category!;
    final AsyncValue<List<Product>> products = ref.watch(
      productsByCategoryProvider(slug),
    );
    final String title = CategoryStyle.of(slug).displayName;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: const <Widget>[CartIconButton()],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int columns = AppBreakpoints.productColumns(
              constraints.maxWidth,
            );
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(productsByCategoryProvider(slug));
                await ref.read(productsByCategoryProvider(slug).future);
              },
              child: products.when(
                data: (List<Product> items) {
                  if (items.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const <Widget>[
                        SizedBox(height: 120),
                        EmptyView(
                          title: AppStrings.emptyProductsTitle,
                          message: AppStrings.emptyProductsMessage,
                        ),
                      ],
                    );
                  }
                  return GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.page),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Product product = items[index];
                      return ProductCard(
                        product: product,
                        onTap: () =>
                            context.push(AppRoutes.productDetails(product.id)),
                      );
                    },
                  );
                },
                loading: () => ProductGridSkeleton(columns: columns),
                error: (Object error, StackTrace stackTrace) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      SizedBox(height: constraints.maxHeight * 0.15),
                      ErrorView(
                        message: userFacingError(error),
                        onRetry: () =>
                            ref.invalidate(productsByCategoryProvider(slug)),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
