import 'package:flutter/material.dart';

import '../schedule/ui/widgets/day_selector_bar.dart';

class DaySelectorPersistentHeader extends StatelessWidget {
  const DaySelectorPersistentHeader({super.key});

  @override
  Widget build(final BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _DaySelectorDelegate(child: const DaySelectorBar()),
    );
  }
}

class _DaySelectorDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _DaySelectorDelegate({required this.child});

  @override
  double get minExtent => 56.0; // Adjust based on your DaySelectorBar height

  @override
  double get maxExtent => 56.0; // Same as minExtent for fixed height

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    return Material(child: child);
  }

  @override
  bool shouldRebuild(final _DaySelectorDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
