import 'package:flutter/material.dart';

import 'ui/sliver_actions_bar.dart';
import 'ui/sliver_date_bar.dart';
import 'ui/sliver_favorite_list.dart';
import 'ui/sliver_title_card.dart';

class OverviewLayout extends StatelessWidget {
  const OverviewLayout({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (final context, final innerBoxIsScrolled) => [
          const SliverTitleCard(),
          const SliverDateBar(),
          const SliverActionsBar(),
          const SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTitleDelegate('Địa điểm yêu thích'),
          ),
        ],
        body: const CustomScrollView(slivers: [SliverFavoriteList()]),
      ),
    );
  }
}

class _StickyTitleDelegate extends SliverPersistentHeaderDelegate {
  final String title;

  const _StickyTitleDelegate(this.title);

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(
    covariant final SliverPersistentHeaderDelegate oldDelegate,
  ) => false;
}
