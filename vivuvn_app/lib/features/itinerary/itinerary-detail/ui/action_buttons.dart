import 'package:flutter/material.dart';

class ActionButtons extends SliverPersistentHeaderDelegate {
  const ActionButtons();

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.surface,
      alignment: Alignment.center,
      child: TabBar(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        labelStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.titleSmall,
        tabs: const [
          Tab(text: 'Tổng quan'),
          Tab(text: 'Lịch trình'),
          Tab(text: 'Ngân sách'),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant final ActionButtons oldDelegate) => false;
}
