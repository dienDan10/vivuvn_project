import 'package:flutter/material.dart';

import '../budget/ui/budget_tab.dart';
import '../overview/ui/place_list.dart';
import '../schedule/schedule_tab.dart';

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
        CustomScrollView(
          slivers: [
            PlaceList(),
            SliverFillRemaining(
              hasScrollBody: false,
              child: SizedBox(height: 5),
            ),
          ],
        ),
        // Tab 2 - Lịch trình
        ScheduleTab(),
        // Scaffold(
        //   body: const Text('Lich trinh trong'),
        //   floatingActionButton: const ButtonGenerateItinerary(),
        //   floatingActionButtonLocation: ExpandableFab.location,
        // ),
        // Tab 3 - Ngân sách
        BudgetTab(),
      ],
    );
  }
}
