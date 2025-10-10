import 'package:flutter/material.dart';

import 'collapsed_appbar.dart';
import 'expanded_appbar_background.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minExtentHeight;
  final double maxExtentHeight;

  CustomSliverAppBarDelegate({
    this.minExtentHeight = kToolbarHeight + 38,
    required this.maxExtentHeight,
  });

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
        Opacity(
          opacity: disappearanceFactor(shrinkOffset),
          child: const ExpandedAppbarBackground(),
        ),

        // Appbar - positioned at the top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: kToolbarHeight + MediaQuery.of(context).padding.top,
          child: Opacity(
            opacity: appearanceFactor(shrinkOffset),
            child: const CollapsedAppbar(),
          ),
        ),
      ],
    );
  }

  double disappearanceFactor(final double shrinkOffset) {
    final totalScrollDistance = maxExtentHeight - minExtentHeight;
    final halfwayPoint = totalScrollDistance * 0.8;

    if (shrinkOffset <= halfwayPoint) {
      return 1.0; // Fully visible until halfway
    }

    final remainingDistance = totalScrollDistance - halfwayPoint;
    final factor = 1 - ((shrinkOffset - halfwayPoint) / remainingDistance);
    return factor.clamp(0.0, 1.0);
  }

  double appearanceFactor(final double shrinkOffset) {
    final totalScrollDistance = maxExtentHeight - minExtentHeight;
    final halfwayPoint = totalScrollDistance * 0.8;

    if (shrinkOffset <= halfwayPoint) {
      return 0.0; // Hidden until halfway
    }

    final remainingDistance = totalScrollDistance - halfwayPoint;
    final factor = (shrinkOffset - halfwayPoint) / remainingDistance;
    return factor.clamp(0.0, 1.0);
  }

  @override
  double get maxExtent => maxExtentHeight;

  @override
  double get minExtent => minExtentHeight;

  @override
  bool shouldRebuild(
    covariant final SliverPersistentHeaderDelegate oldDelegate,
  ) {
    return oldDelegate.maxExtent != maxExtentHeight ||
        oldDelegate.minExtent != minExtentHeight;
  }
}
