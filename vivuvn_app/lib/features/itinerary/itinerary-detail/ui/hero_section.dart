import 'package:flutter/material.dart';

import '../../../../common/helper/app_constants.dart';
import '../../view-itinerary-list/models/itinerary.dart';
import 'custom_sliver_appbar_delegate.dart';

class HeroSection extends StatelessWidget {
  final Itinerary itinerary;
  const HeroSection({super.key, required this.itinerary});

  @override
  Widget build(final BuildContext context) {
    return SliverPersistentHeader(
      delegate: CustomSliverAppBarDelegate(
        itinerary: itinerary,
        maxExtentHeight: appbarExpandedHeight,
        minExtentHeight: MediaQuery.of(context).padding.top + kToolbarHeight,
      ),
      pinned: true,
      floating: false,
    );
  }
}
