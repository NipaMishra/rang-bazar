import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/error_message.dart';
import '../../../../core/widgets/catalog_cards.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/feedback_views.dart';
import '../../../../core/widgets/promo_carousel.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../../../core/widgets/shop_bottom_nav.dart';
import '../../../../core/widgets/shop_scaffold.dart';
import '../../domain/models/category.dart';
import '../../domain/models/product.dart';
import '../providers/catalog_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _search = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Product> _visibleProducts(List<Product> products) {
    final String query = _search.text.trim().toLowerCase();
    return products
        .where((Product product) {
          final bool matchesCategory =
              _selectedCategory == null ||
              product.category == _selectedCategory;
          final bool matchesQuery =
              query.isEmpty || product.title.toLowerCase().contains(query);
          return matchesCategory && matchesQuery;
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Category>> categories = ref.watch(categoriesProvider);
    final AsyncValue<List<Product>> products = ref.watch(allProductsProvider);

    return ShopScaffold(
      current: ShopTab.home,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int columns = AppBreakpoints.productColumns(
              constraints.maxWidth,
            );
            return RefreshIndicator(
              onRefresh: () async {
                ref
                  ..invalidate(categoriesProvider)
                  ..invalidate(allProductsProvider);
                await Future.wait<void>(<Future<void>>[
                  ref.read(categoriesProvider.future),
                  ref.read(allProductsProvider.future),
                ]);
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page,
                      AppSpacing.xs,
                      AppSpacing.page,
                      AppSpacing.md,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Builder(
                                builder: (BuildContext context) {
                                  return IconButton(
                                    tooltip: AppStrings.menuTooltip,
                                    onPressed: () =>
                                        Scaffold.of(context).openDrawer(),
                                    icon: const Icon(Icons.menu_rounded),
                                  );
                                },
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _search,
                                  textInputAction: TextInputAction.search,
                                  onChanged: (_) => setState(() {}),
                                  decoration: const InputDecoration(
                                    hintText: AppStrings.searchHint,
                                    prefixIcon: Icon(Icons.search_rounded),
                                    isDense: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: AppStrings.filterTooltip,
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                        content: Text(AppStrings.filterSoon),
                                      ),
                                    );
                                },
                                icon: const Icon(Icons.tune_rounded),
                              ),
                              IconButton(
                                tooltip: AppStrings.alertsTooltip,
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                        content: Text(AppStrings.alertsEmpty),
                                      ),
                                    );
                                },
                                icon: const Icon(
                                  Icons.notifications_none_rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          PromoCarousel(
                            onShop: (PromoSlide slide) {
                              setState(
                                () => _selectedCategory = slide.categorySlug,
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          categories.when(
                            loading: () => const SizedBox(
                              height: 86,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            error: (Object error, StackTrace stackTrace) =>
                                ErrorView(
                                  message: userFacingError(error),
                                  onRetry: () =>
                                      ref.invalidate(categoriesProvider),
                                ),
                            data: (List<Category> items) {
                              return SizedBox(
                                height: 82,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    CategoryChip.all(
                                      selected: _selectedCategory == null,
                                      onTap: () => setState(
                                        () => _selectedCategory = null,
                                      ),
                                    ),
                                    ...items.map((Category category) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          left: AppSpacing.sm,
                                        ),
                                        child: CategoryChip.fromSlug(
                                          slug: category.slug,
                                          selected:
                                              _selectedCategory ==
                                              category.slug,
                                          onTap: () => setState(
                                            () => _selectedCategory =
                                                category.slug,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: <Widget>[
                              const Expanded(
                                child: SectionHeader(
                                  title: AppStrings.specialForYou,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_selectedCategory != null) {
                                    context.push(
                                      AppRoutes.productList(
                                        _selectedCategory!,
                                      ),
                                    );
                                    return;
                                  }
                                  final List<Category>? items = categories
                                      .asData
                                      ?.value;
                                  if (items != null && items.isNotEmpty) {
                                    context.push(
                                      AppRoutes.productList(items.first.slug),
                                    );
                                  }
                                },
                                child: const Text(AppStrings.seeAll),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...products.when(
                    loading: () => <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.page,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: SizedBox(
                            height: 360,
                            child: ProductGridSkeleton(columns: columns),
                          ),
                        ),
                      ),
                    ],
                    error: (Object error, StackTrace stackTrace) => <Widget>[
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: ErrorView(
                          message: userFacingError(error),
                          onRetry: () => ref.invalidate(allProductsProvider),
                        ),
                      ),
                    ],
                    data: (List<Product> items) {
                      final List<Product> visible = _visibleProducts(items);
                      if (visible.isEmpty) {
                        return <Widget>[
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: EmptyView(
                              title: AppStrings.emptyProductsTitle,
                              message: AppStrings.emptyProductsMessage,
                            ),
                          ),
                        ];
                      }
                      return <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.page,
                            0,
                            AppSpacing.page,
                            AppSpacing.lg,
                          ),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  mainAxisSpacing: AppSpacing.md,
                                  crossAxisSpacing: AppSpacing.md,
                                  childAspectRatio: 0.78,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              BuildContext context,
                              int index,
                            ) {
                              final Product product = visible[index];
                              return ProductCard(
                                product: product,
                                onTap: () => context.push(
                                  AppRoutes.productDetails(product.id),
                                ),
                              );
                            }, childCount: visible.length),
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
