import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home_screen.dart';

final goRouterProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (final context, final state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (final context, final state) {
          return const Scaffold(body: Center(child: Text('Login Page')));
        },
      ),
    ],
  );
});
