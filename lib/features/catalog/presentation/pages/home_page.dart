import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/error_message.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/catalog_cards.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/feedback_views.dart';
import '../../../../core/widgets/promo_carousel.dart';
import '../../../../core/widgets/search_field.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../../../core/widgets/shop_bottom_nav.dart';
import '../../../../core/widgets/shop_scaffold.dart';
import '../../../../core/widgets/soft_icon_button.dart';
import '../../../cart/presentation/widgets/cart_strap.dart';
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
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Product> _visibleProducts(List<Product> products) {
    final String query = _query.trim().toLowerCase();
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

  void _soon(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openSeeAll(AsyncValue<List<Category>> categories) {
    String? slug = _selectedCategory;
    if (slug == null) {
      final List<Category>? items = categories.asData?.value;
      if (items == null || items.isEmpty) return;
      slug = items.first.slug;
    }
    context.push(AppRoutes.productList(slug));
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Category>> categories = ref.watch(categoriesProvider);
    final AsyncValue<List<Product>> products = ref.watch(allProductsProvider);

    return ShopScaffold(
      current: ShopTab.home,
      footer: const CartStrap(),
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
                          AppFadeIn(
                            child: Row(
                              children: <Widget>[
                                Builder(
                                  builder: (BuildContext context) {
                                    return SoftIconButton(
                                      icon: Icons.grid_view_rounded,
                                      tooltip: AppStrings.menuTooltip,
                                      onPressed: () =>
                                          Scaffold.of(context).openDrawer(),
                                    );
                                  },
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: SearchField(
                                    controller: _search,
                                    onChanged: (String value) =>
                                        setState(() => _query = value),
                                    onFilter: () =>
                                        _soon(AppStrings.filterSoon),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                SoftIconButton(
                                  icon: Icons.notifications_none_rounded,
                                  tooltip: AppStrings.alertsTooltip,
                                  onPressed: () =>
                                      _soon(AppStrings.alertsEmpty),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppFadeIn(
                            delay: const Duration(milliseconds: 80),
                            child: PromoCarousel(
                              onShop: (PromoSlide slide) {
                                setState(
                                  () => _selectedCategory = slide.categorySlug,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppFadeIn(
                            delay: const Duration(milliseconds: 140),
                            child: categories.when(
                              loading: () => const SizedBox(
                                height: 82,
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
                                    physics: const BouncingScrollPhysics(),
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
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppFadeIn(
                            delay: const Duration(milliseconds: 200),
                            child: SectionHeader(
                              title: _query.trim().isEmpty
                                  ? AppStrings.specialForYou
                                  : '${AppStrings.resultsFor} "${_query.trim()}"',
                              actionLabel: AppStrings.seeAll,
                              onAction: () => _openSeeAll(categories),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                      ),
                    ),
                  ),
                  ...products.when(
                    loading: () => <Widget>[
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 380,
                          child: ProductGridSkeleton(
                            columns: columns,
                            rows: 2,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.page,
                            ),
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
                              icon: Icons.search_off_rounded,
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
                                  childAspectRatio: 0.72,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              BuildContext context,
                              int index,
                            ) {
                              final Product product = visible[index];
                              return AppFadeIn.staggered(
                                index: index,
                                child: ProductCard(
                                  product: product,
                                  onTap: () => context.push(
                                    AppRoutes.productDetails(product.id),
                                  ),
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
