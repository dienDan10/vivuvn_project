import 'package:flutter/material.dart';

import 'background_title.dart';

class ItineraryOverviewAppBar extends StatelessWidget {
  const ItineraryOverviewAppBar({super.key});

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverAppBar(
      pinned: true,
      expandedHeight: 220,
      backgroundColor: colorScheme.primary,
      leading: const BackButton(),
      flexibleSpace: LayoutBuilder(
        builder: (final context, final constraints) {
          final bool collapsed = constraints.maxHeight <= kToolbarHeight + 40;

          return FlexibleSpaceBar(
            centerTitle: true,
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 20),
              opacity: collapsed ? 1.0 : 0.0,
              child: const Text(
                'Tham quan Đà Nẵng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            background: const BackgroundTitle(),
          );
        },
      ),
    );
  }
}
