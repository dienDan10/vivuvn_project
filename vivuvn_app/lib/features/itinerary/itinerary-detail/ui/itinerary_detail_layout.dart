import 'package:flutter/material.dart';

import '../../../../common/helper/app_constants.dart';
import 'hero_section.dart';
import 'tabbar_content.dart';
import 'tabbar_header.dart';

class ItineraryDetailLayout extends StatefulWidget {
  final int itineraryId;
  const ItineraryDetailLayout({super.key, required this.itineraryId});

  @override
  State<ItineraryDetailLayout> createState() => _ItineraryDetailLayoutState();
}

class _ItineraryDetailLayoutState extends State<ItineraryDetailLayout>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _registerListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _registerListener() {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index != 0) {
          _scrollController.animateTo(
            appbarExpandedHeight -
                (kToolbarHeight + MediaQuery.of(context).padding.top),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (final context, final innerBoxIsScrolled) => [
          const HeroSection(),
          TabbarHeader(tabController: _tabController),
        ],
        body: Column(
          children: [
            Expanded(child: TabbarContent(tabController: _tabController)),
          ],
        ),
      ),
    );
  }
}
