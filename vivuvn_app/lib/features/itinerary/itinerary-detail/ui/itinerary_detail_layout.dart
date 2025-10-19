import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/helper/app_constants.dart';
import '../controller/itinerary_detail_controller.dart';
import 'hero_section.dart';
import 'tabbar_content.dart';
import 'tabbar_header.dart';

class ItineraryDetailLayout extends ConsumerStatefulWidget {
  const ItineraryDetailLayout({super.key});

  @override
  ConsumerState<ItineraryDetailLayout> createState() =>
      _ItineraryDetailLayoutState();
}

class _ItineraryDetailLayoutState extends ConsumerState<ItineraryDetailLayout>
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
    final detailState = ref.watch(itineraryDetailControllerProvider);
    // load itinerary detail
    ref.listen(
      itineraryDetailControllerProvider.select(
        (final state) => state.itineraryId,
      ),
      (final previous, final next) {
        ref
            .read(itineraryDetailControllerProvider.notifier)
            .fetchItineraryDetail();
      },
    );

    if (detailState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (detailState.error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Lỗi: ${detailState.error}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (detailState.itinerary == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Không tìm thấy chi tiết hành trình.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (final context, final innerBoxIsScrolled) => [
          HeroSection(itinerary: detailState.itinerary!),
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
