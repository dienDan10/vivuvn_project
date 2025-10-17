import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/auth/auth_controller.dart';
import '../../common/auth/auth_state.dart';
import '../../features/itinerary/itinerary-detail/ui/itinerary_detail_layout.dart';
import '../../screens/bottom_navigation_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/itinerary_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/route_error_screen.dart';
import '../../screens/search_screen.dart';
import '../../screens/splash_screen.dart';
import 'go_router_notifier.dart';
import 'routes.dart';

final goRouterProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    // initialLocation: splashRoute,
    initialLocation: itineraryDetailRoute,
    errorBuilder: (final context, final state) => RouteErrorScreen(
      error: state.error.toString(),
      path: state.uri.toString(),
    ),
    refreshListenable: GoRouterNotifier(ref),
    redirect: (final context, final state) {
      final location = state.fullPath;
      final authStatus = ref.read(
        authControllerProvider.select((final state) => state.status),
      );

      // Show splash screen while checking auth status
      // if (authStatus == AuthStatus.unknown) {
      //   return location == '/splash' ? null : '/splash';
      // }

      // If unauthenticated, redirect to login (except if already on login/signup)
      if (authStatus == AuthStatus.unauthenticated) {
        if (location == loginRoute || location == registerRoute) {
          return null; // Stay on current auth-related screen
        }
        return loginRoute;
      }

      // If authenticated, redirect away from auth screens to home
      if (authStatus == AuthStatus.authenticated) {
        if (location == loginRoute ||
            location == registerRoute ||
            location == '/splash') {
          return homeRoute;
        }
        return null; // Stay on current authenticated screen
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: splashRoute,
        builder: (final context, final state) => const SplashScreen(),
      ),

      GoRoute(
        path: loginRoute,
        builder: (final context, final state) => const LoginScreen(),
      ),

      GoRoute(
        path: registerRoute,
        builder: (final context, final state) => const RegisterScreen(),
      ),

      GoRoute(
        path: itineraryDetailRoute,
        builder: (final context, final state) => const ItineraryDetailLayout(),
      ),
      // Route with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder:
            (
              final BuildContext context,
              final GoRouterState state,
              final StatefulNavigationShell navigationShell,
            ) => BottomNavigationScreen(navigationShell: navigationShell),

        branches: <StatefulShellBranch>[
          // Home Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: homeRoute,
                builder: (final context, final state) => const HomeScreen(),
              ),
            ],
          ),

          // Itinerary Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: itineraryRoute,
                builder: (final context, final state) =>
                    const ItineraryScreen(),
              ),
            ],
          ),

          // Search Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: searchRoute,
                builder: (final context, final state) => const SearchScreen(),
              ),
            ],
          ),
          // Profile Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: profileRoute,
                builder: (final context, final state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
