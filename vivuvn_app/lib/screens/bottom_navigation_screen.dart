import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/notification/ui/notification_badge.dart';

class BottomNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavigationScreen({super.key, required this.navigationShell});

  void _onItemTapped(final BuildContext context, final int index) {
    // Pop all modals/dialogs in current tab before switching
    if (index != navigationShell.currentIndex) {
      // Get the navigator key of the current branch
      final navigatorKey = navigationShell.shellRouteContext.navigatorKey;
      final currentContext = navigatorKey.currentContext;

      // Pop all routes except the first one in the current tab
      if (currentContext != null) {
        Navigator.of(currentContext).popUntil((final route) => route.isFirst);
      }
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (final index) => _onItemTapped(context, index),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore),
            label: 'Lịch trình',
          ),
          BottomNavigationBarItem(
            icon: NotificationBadge(child: Icon(Icons.notifications)),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}
