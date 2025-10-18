import 'package:flutter/material.dart';

import '../budget/ui/budget_tab.dart';
import '../overview/ui/place_list.dart';
import '../schedule/ui/schedule_tab.dart';

class TabbarContent extends StatelessWidget {
  final TabController tabController;
  final int itineraryId;
  const TabbarContent({
    super.key,
    required this.tabController,
    required this.itineraryId,
  });

  @override
  Widget build(final BuildContext context) {
    return TabBarView(
      controller: tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Tab 1 - Tổng quan
        const CustomScrollView(
          slivers: [
            PlaceList(),
            SliverFillRemaining(
              hasScrollBody: false,
              child: SizedBox(height: 5),
            ),
          ],
        ),
        // Tab 2 - Lịch trình
        ScheduleTab(itineraryId: itineraryId),
        // Scaffold(
        //   body: const Text('Lich trinh trong'),
        //   floatingActionButton: const ButtonGenerateItinerary(),
        //   floatingActionButtonLocation: ExpandableFab.location,
        // ),
        // Tab 3 - Ngân sách
        const BudgetTab(),
      ],
    );
  }
}
