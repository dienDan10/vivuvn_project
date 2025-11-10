import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/theme/app_theme.dart';
import 'core/routes/app_route.dart';
import 'core/services/fcm_service.dart';
import 'core/services/theme_service.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    final fcmService = ref.read(fcmServiceProvider);
    await fcmService.requestPermission();
  }

  @override
  Widget build(final BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeServiceProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'VivuVN App',
      // theme configuration
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // route configuration
      routerConfig: goRouter,
    );
  }
}
