import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../screens/bottom_navigation_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/itinerary_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/route_error_screen.dart';
import '../../screens/search_screen.dart';
import 'routes.dart';

final goRouterProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    initialLocation: homeRoute,
    errorBuilder: (final context, final state) => RouteErrorScreen(
      error: state.error.toString(),
      path: state.uri.toString(),
    ),
    routes: <RouteBase>[
      GoRoute(
        path: loginRoute,
        builder: (final context, final state) {
          return const Scaffold(body: Center(child: Text('Login Page')));
        },
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

          // Search Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: searchRoute,
                builder: (final context, final state) => const SearchScreen(),
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
