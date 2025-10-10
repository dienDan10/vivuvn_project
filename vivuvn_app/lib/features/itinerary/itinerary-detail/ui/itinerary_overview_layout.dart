import 'package:flutter/material.dart';

import 'widget/app_bar.dart';
import 'widget/place_list.dart';

class ItineraryOverviewLayout extends StatefulWidget {
  const ItineraryOverviewLayout({super.key});

  @override
  State<ItineraryOverviewLayout> createState() =>
      _ItineraryOverviewLayoutState();
}

class _ItineraryOverviewLayoutState extends State<ItineraryOverviewLayout> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (final context) {
          final tabController = DefaultTabController.of(context);

          tabController.addListener(() {
            if (tabController.indexIsChanging) {
              if (tabController.index != 0) {
                _scrollController.animateTo(
                  220,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            }
          });

          return Scaffold(
            body: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (final context, final innerBoxIsScrolled) =>
                  const [
                    ItineraryOverviewAppBar(),
                    // SliverPersistentHeader(
                    //   pinned: true,
                    //   delegate: ActionButtons(),
                    // ),
                  ],
              body: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    alignment: Alignment.center,
                    child: TabBar(
                      labelColor: Theme.of(context).colorScheme.primary,
                      unselectedLabelColor: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant,
                      indicatorColor: Theme.of(context).colorScheme.primary,
                      labelStyle: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      unselectedLabelStyle: Theme.of(
                        context,
                      ).textTheme.titleSmall,
                      tabs: const [
                        Tab(text: 'Tổng quan'),
                        Tab(text: 'Lịch trình'),
                        Tab(text: 'Ngân sách'),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
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
                        Center(child: Text('Lịch trình trống')),
                        // Tab 3 - Ngân sách
                        Center(child: Text('Ngân sách trống')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
