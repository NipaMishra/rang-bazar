import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/catalog/presentation/pages/home_page.dart';
import '../../features/catalog/presentation/pages/product_details_page.dart';
import '../../features/catalog/presentation/pages/product_list_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/wishlist/presentation/pages/favorites_page.dart';
import 'app_routes.dart';

/// Cross-fade used for tab-level destinations, where a push animation would
/// imply depth the navigation does not have.
CustomTransitionPage<void> _fadePage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          final Animation<double> curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.02),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          _fadePage(const SplashPage(), state),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          _fadePage(const LoginPage(), state),
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          _fadePage(const HomePage(), state),
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
      pageBuilder: (BuildContext context, GoRouterState state) =>
          _fadePage(const CartPage(), state),
    ),
    GoRoute(
      path: AppRoutes.favorites,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          _fadePage(const FavoritesPage(), state),
    ),
    GoRoute(
      path: AppRoutes.profile,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          _fadePage(const ProfilePage(), state),
    ),
  ],
);
