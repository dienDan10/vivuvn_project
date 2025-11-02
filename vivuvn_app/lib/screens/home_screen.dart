import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../common/auth/auth_controller.dart';
import '../core/routes/routes.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _logout(final WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text('Home Screen'),
              ElevatedButton(
                onPressed: () {
                  _logout(ref);
                },
                child: const Text('Logout'),
              ),

              ElevatedButton(
                onPressed: () {
                  context.push(nearbyRestaurantRoute);
                },
                child: const Text('Nearby Restaurant'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.push(nearbyHotelRoute);
                },
                child: const Text('Nearby Hotel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
