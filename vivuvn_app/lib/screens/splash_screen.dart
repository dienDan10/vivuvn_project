import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../common/auth/controller/auth_controller.dart';
import '../common/auth/state/auth_state.dart';
import '../core/routes/routes.dart';
import '../core/services/notification_handler.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    // check auth status when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });

    super.initState();
  }

  Future<void> _initialize() async {
    // Initialize notification handler because it may need to handle notification taps
    final handler = ref.read(notificationHandlerProvider);
    await handler.initialize();

    // Check auth status
    await ref.read(authControllerProvider.notifier).checkAuthStatus();
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      // Let scaffold use the app theme background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular logo with subtle gradient and shadow using theme colors
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.18),
                    colorScheme.primary.withValues(alpha: 0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.14),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset(
                    'assets/images/app-logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // App name using theme text styles
            Text(
              'ViVuVN',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Du lịch Việt Nam',
              style: textTheme.bodyMedium?.copyWith(
                color:
                    textTheme.bodySmall?.color?.withValues(alpha: 0.85) ??
                    colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),

            const SizedBox(height: 40),

            // Loading indicator using theme primary color
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              strokeWidth: 3,
            ),
            const SizedBox(height: 12),

            Text(
              'Đang tải...',
              style: textTheme.bodyMedium?.copyWith(
                color:
                    textTheme.bodySmall?.color?.withValues(alpha: 0.75) ??
                    colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
