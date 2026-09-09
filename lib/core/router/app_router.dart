import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/catalog/presentation/pages/home_page.dart';
import '../../features/catalog/presentation/pages/product_details_page.dart';
import '../../features/catalog/presentation/pages/product_list_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      builder: (BuildContext context, GoRouterState state) =>
          const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.products,
      builder: (BuildContext context, GoRouterState state) {
        return ProductListPage(category: state.uri.queryParameters['category']);
      },
    ),
    GoRoute(
      path: AppRoutes.product,
      builder: (BuildContext context, GoRouterState state) {
        return ProductDetailsPage(
          productId: int.tryParse(state.pathParameters['id'] ?? ''),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.cart,
      builder: (BuildContext context, GoRouterState state) => const CartPage(),
    ),
  ],
);
