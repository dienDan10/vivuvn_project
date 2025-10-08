import 'package:flutter/material.dart';

class SliverDateBar extends StatelessWidget {
  const SliverDateBar({super.key});

  @override
  Widget build(final BuildContext context) {
    return const SliverAppBar(
      pinned: false,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false, // không hiện nút back
      toolbarHeight: 30,
      flexibleSpace: Center(
        child: Text(
          '22/10 → 25/10, 2025',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}
