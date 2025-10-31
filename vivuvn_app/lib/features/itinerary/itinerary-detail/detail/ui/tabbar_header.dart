import 'package:flutter/material.dart';

class TabbarHeader extends StatelessWidget {
  final TabController tabController;
  const TabbarHeader({super.key, required this.tabController});

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        controller: tabController,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        indicatorColor: Theme.of(context).colorScheme.primary,
        labelStyle: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
        tabs: const [
          Tab(text: 'Tổng quan'),
          Tab(text: 'Lịch trình'),
          Tab(text: 'Ngân sách'),
        ],
      ),
    );
  }
}
