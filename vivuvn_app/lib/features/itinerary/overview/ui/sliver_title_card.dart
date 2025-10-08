import 'package:flutter/material.dart';

class SliverTitleCard extends StatelessWidget {
  const SliverTitleCard({super.key});

  @override
  Widget build(final BuildContext context) {
    return const SliverAppBar(
      pinned: true,
      expandedHeight: 120,
      backgroundColor: Colors.green,

      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'Hội An Trip',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
