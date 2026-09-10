abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String products = '/products';
  static const String product = '/product/:id';
  static const String cart = '/cart';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  static String productDetails(int id) => '/product/$id';

  static String productList(String category) {
    return Uri(
      path: products,
      queryParameters: <String, String>{'category': category},
    ).toString();
  }
}
