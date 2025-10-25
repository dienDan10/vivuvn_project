import 'package:flutter/material.dart';

import '../budget/ui/budget_tab.dart';
import '../overview/ui/overview_tab_layout.dart';
import '../schedule/ui/schedule_tab.dart';

class TabbarContent extends StatelessWidget {
  final TabController tabController;
  const TabbarContent({super.key, required this.tabController});

  @override
  Widget build(final BuildContext context) {
    return TabBarView(
      controller: tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        // Tab 1 - Tổng quan
        OverviewTabLayout(),
        // Tab 2 - Lịch trình
        ScheduleTab(),
        // Tab 3 - Ngân sách
        BudgetTab(),
      ],
    );
  }
}
