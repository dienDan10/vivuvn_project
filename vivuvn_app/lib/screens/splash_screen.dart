import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../common/auth/auth_controller.dart';
import '../common/auth/auth_state.dart';
import '../core/routes/routes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Future<void> _checkAuthStatus() async {
    ref.read(authControllerProvider.notifier).checkAuthStatus();
  }

  @override
  void initState() {
    // check auth status when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });

    super.initState();
  }

  void _listener() {
    ref.listen(authControllerProvider.select((final state) => state.status), (
      final previous,
      final next,
    ) {
      if (next == AuthStatus.authenticated) {
        // Navigate to the main screen
        context.go(homeRoute);
      } else if (next == AuthStatus.unauthenticated) {
        // Navigate to the login screen
        context.go(loginRoute);
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    _listener();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or name (you can replace this with your actual logo)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.travel_explore,
                size: 60,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(height: 40),

            // App name
            Text(
              'ViVuVN',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Travel Vietnam',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 60),

            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),

            Text(
              'Loading...',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
