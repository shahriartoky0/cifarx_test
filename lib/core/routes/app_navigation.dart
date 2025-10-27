import 'package:cifarx_test/core/routes/app_routes.dart';
import 'package:cifarx_test/features/auth/presentation/views/screens/login_screen.dart';
import 'package:cifarx_test/features/home/presentation/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppNavigation {
  AppNavigation._();

  static final GoRouter goRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.initialRoute,
    routes: <RouteBase>[
      // Home Screen route
      GoRoute(
        path: AppRoutes.initialRoute,
        builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
      ),
      // Home Screen route
      GoRoute(
        path: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
      ),
      // Login Screen route
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
    ],
  );
}
