import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/notification/ui/notification_badge.dart';

class BottomNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavigationScreen({super.key, required this.navigationShell});

  void _onItemTapped(final int index) {
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
        onTap: _onItemTapped,
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
