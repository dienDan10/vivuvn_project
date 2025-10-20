import 'package:flutter/material.dart';

import '../../view-itinerary-list/models/itinerary.dart';
import 'collapsed_appbar.dart';
import 'expanded_appbar_background.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minExtentHeight;
  final double maxExtentHeight;
  final Itinerary itinerary;

  CustomSliverAppBarDelegate({
    required this.itinerary,
    required this.maxExtentHeight,
    this.minExtentHeight = kToolbarHeight + 38,
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
        // Background (hiển thị khi expand)
        Opacity(
          opacity: disappearanceFactor(shrinkOffset),
          child: ExpandedAppbarBackground(itinerary: itinerary),
        ),

        // Collapsed appbar (hiển thị khi thu nhỏ)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: kToolbarHeight + MediaQuery.of(context).padding.top,
          child: Opacity(
            opacity: appearanceFactor(shrinkOffset),
            child: CollapsedAppbar(itinerary: itinerary),
          ),
        ),
      ],
    );
  }

  double disappearanceFactor(final double shrinkOffset) {
    final total = maxExtentHeight - minExtentHeight;
    final halfway = total * 0.8;
    if (shrinkOffset <= halfway) return 1.0;
    final factor = 1 - ((shrinkOffset - halfway) / (total - halfway));
    return factor.clamp(0.0, 1.0);
  }

  double appearanceFactor(final double shrinkOffset) {
    final total = maxExtentHeight - minExtentHeight;
    final halfway = total * 0.8;
    if (shrinkOffset <= halfway) return 0.0;
    final factor = (shrinkOffset - halfway) / (total - halfway);
    return factor.clamp(0.0, 1.0);
  }

  @override
  double get maxExtent => maxExtentHeight;
  @override
  double get minExtent => minExtentHeight;

  @override
  bool shouldRebuild(covariant final CustomSliverAppBarDelegate oldDelegate) =>
      oldDelegate.itinerary != itinerary ||
      oldDelegate.maxExtentHeight != maxExtentHeight;
}
