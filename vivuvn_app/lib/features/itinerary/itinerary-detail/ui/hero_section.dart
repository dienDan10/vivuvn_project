import 'package:flutter/material.dart';

import '../../../../common/helper/app_constants.dart';
import 'custom_sliver_appbar_delegate.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(final BuildContext context) {
    return SliverPersistentHeader(
      delegate: CustomSliverAppBarDelegate(
        maxExtentHeight: appbarExpandedHeight,
        minExtentHeight: MediaQuery.of(context).padding.top + kToolbarHeight,
      ),
      pinned: true,
      floating: false,
    );
  }
}
