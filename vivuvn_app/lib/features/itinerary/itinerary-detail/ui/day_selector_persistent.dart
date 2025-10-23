import 'package:flutter/material.dart';

import '../schedule/ui/widgets/day_selector_bar.dart';

class DaySelectorPersistent extends StatelessWidget {
  const DaySelectorPersistent({super.key});

  @override
  Widget build(final BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      toolbarHeight: 10.0,
      expandedHeight: 10.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: const FlexibleSpaceBar(background: DaySelectorBar()),
    );
  }
}
