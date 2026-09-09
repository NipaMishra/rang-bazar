import '../../../core/constants/api_constants.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/models/category.dart';
import '../domain/models/product.dart';

class CatalogRepository {
  CatalogRepository(this._client);

  final DioClient _client;

  Future<List<Category>> fetchCategories() async {
    final dynamic data = await _client.get<dynamic>(ApiConstants.categories);
    if (data is! List<dynamic>) {
      throw const AppException('Unexpected categories response.');
    }
    return data
        .map((dynamic item) => Category.fromApi(item.toString()))
        .where((Category category) => category.slug.isNotEmpty)
        .toList(growable: false);
  }

  Future<List<Product>> fetchProducts() async {
    final dynamic data = await _client.get<dynamic>(ApiConstants.products);
    return _parseProducts(data);
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final dynamic data = await _client.get<dynamic>(
      ApiConstants.productsByCategory(category),
    );
    return _parseProducts(data);
  }

  Future<Product> fetchProduct(int id) async {
    final dynamic data = await _client.get<dynamic>(ApiConstants.product(id));
    if (data is! Map) {
      throw const AppException('Unexpected product response.');
    }
    return Product.fromJson(Map<String, dynamic>.from(data));
  }

  List<Product> _parseProducts(dynamic data) {
    if (data is! List<dynamic>) {
      throw const AppException('Unexpected products response.');
    }
    return data
        .whereType<Map<dynamic, dynamic>>()
        .map(
          (Map<dynamic, dynamic> item) =>
              Product.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList(growable: false);
  }
}
