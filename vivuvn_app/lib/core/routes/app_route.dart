import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/auth/controller/auth_controller.dart';
import '../../common/auth/state/auth_state.dart';
import '../../features/itinerary/itinerary-detail/schedule/model/location.dart';
import '../../features/itinerary/location-detail/ui/location_detail_screen.dart';
import '../../screens/bottom_navigation_screen.dart';
import '../../screens/chat_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/itinerary_detail_screen.dart';
import '../../screens/itinerary_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/nearby_hotel_screen.dart';
import '../../screens/nearby_restaurant_screen.dart';
import '../../screens/notification_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/public_itinerary_view_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/route_error_screen.dart';
import '../../screens/splash_screen.dart';
import 'go_router_notifier.dart';
import 'routes.dart';

final goRouterProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    // initialLocation: splashRoute,
    initialLocation: splashRoute,
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
        builder: (final context, final state) {
          final itineraryId = state.pathParameters['id']!;
          return ItineraryDetailScreen(itineraryId: int.parse(itineraryId));
        },
      ),

      GoRoute(
        path: locationDetailRoute,
        builder: (final context, final state) {
          final id = int.parse(state.pathParameters['id']!);
          return LocationDetailScreen(locationId: id);
        },
      ),

      GoRoute(
        path: publicItineraryViewRoute,
        builder: (final context, final state) {
          final itineraryId = state.pathParameters['id']!;
          return PublicItineraryViewScreen(itineraryId: itineraryId);
        },
      ),

      GoRoute(
        path: nearbyRestaurantRoute,
        builder: (final context, final state) {
          final location = state.extra as Location;
          return NearbyRestaurantScreen(location: location);
        },
      ),

      GoRoute(
        path: nearbyHotelRoute,
        builder: (final context, final state) {
          final location = state.extra as Location;
          return NearbyHotelScreen(location: location);
        },
      ),

      GoRoute(
        path: chatRoute,
        builder: (final context, final state) {
          final itineraryId = state.pathParameters['id']!;
          return ChatScreen(itineraryId: int.parse(itineraryId));
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
                path: notificationRoute,
                builder: (final context, final state) =>
                    const NotificationScreen(),
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
