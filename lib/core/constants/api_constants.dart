abstract final class ApiConstants {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String products = '/products';
  static const String categories = '/products/categories';

  static String productsByCategory(String category) =>
      '/products/category/$category';

  static String product(int id) => '/products/$id';
}
