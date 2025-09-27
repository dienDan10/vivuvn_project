import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../screens/home_screen.dart';
import '../../screens/route_error_screen.dart';
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
        path: homeRoute,
        builder: (final context, final state) => const HomeScreen(),
      ),
      GoRoute(
        path: loginRoute,
        builder: (final context, final state) {
          return const Scaffold(body: Center(child: Text('Login Page')));
        },
      ),
    ],
  );
});
