import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/category.dart';
import '../../domain/models/product.dart';
import '../../../../core/network/providers.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(catalogRepositoryProvider).fetchCategories();
});

final allProductsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(catalogRepositoryProvider).fetchProducts();
});

final productsByCategoryProvider = FutureProvider.family<List<Product>, String>(
  (ref, String category) {
    return ref
        .watch(catalogRepositoryProvider)
        .fetchProductsByCategory(category);
  },
);

final productDetailsProvider = FutureProvider.family<Product, int>((
  ref,
  int id,
) {
  return ref.watch(catalogRepositoryProvider).fetchProduct(id);
});
