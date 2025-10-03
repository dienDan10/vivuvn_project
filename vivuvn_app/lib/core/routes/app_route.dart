import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/auth/auth_controller.dart';
import '../../common/auth/auth_state.dart';
import '../../screens/bottom_navigation_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/intro/intro_screen.dart';
import '../../screens/itinerary_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/route_error_screen.dart';
import '../../screens/search_screen.dart';
import 'go_router_notifier.dart';
import 'routes.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final asyncSeenIntro = ref.watch(seenIntroProvider);

  // Nếu chưa load xong seenIntro -> show tạm Intro
  final initialLoc = asyncSeenIntro.valueOrNull == true ? homeRoute : introRoute;

  return GoRouter(
    initialLocation: initialLoc,
    errorBuilder: (context, state) => RouteErrorScreen(
      error: state.error.toString(),
      path: state.uri.toString(),
    ),
    redirect: (context, state) {
      // --- Check auth logic ---
      final location = state.fullPath;
      final authStatus = ref.read(
        authControllerProvider.select((state) => state.status),
      );

      if (authStatus == AuthStatus.unauthenticated) {
        if (location == loginRoute || location == registerRoute) {
          return null;
        }
        return loginRoute;
      }

      if (authStatus == AuthStatus.authenticated) {
        if (location == loginRoute ||
            location == registerRoute ||
            location == '/splash') {
          return homeRoute;
        }
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: introRoute,
        builder: (context, state) => const IntroScreen(),
      ),
      GoRoute(
        path: loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: registerRoute,
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BottomNavigationScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: homeRoute, builder: (_, __) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: itineraryRoute, builder: (_, __) => const ItineraryScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: searchRoute, builder: (_, __) => const SearchScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: profileRoute, builder: (_, __) => const ProfileScreen())],
          ),
        ],
      ),
    ],
  );
});
