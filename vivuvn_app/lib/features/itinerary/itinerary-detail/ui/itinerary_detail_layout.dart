import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/helper/app_constants.dart';
import '../controller/itinerary_detail_controller.dart';
import '../state/itinerary_detail_state.dart';
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
    ref.listen<ItineraryDetailState>(itineraryDetailControllerProvider, (
      final previous,
      final next,
    ) {
      if (previous?.itineraryId != next.itineraryId &&
          next.itineraryId != null) {
        ref
            .read(itineraryDetailControllerProvider.notifier)
            .fetchItineraryDetail();
      }
    });
  }

  void _registerListener() {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging && _tabController.index != 0) {
        _scrollController.animateTo(
          appbarExpandedHeight -
              (kToolbarHeight + MediaQuery.of(context).padding.top),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final detailState = ref.watch(itineraryDetailControllerProvider);

    // Khi chưa có ID hoặc đang loading
    if (detailState.itineraryId == null || detailState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Khi có lỗi
    if (detailState.error != null && detailState.error != 'unauthorized') {
      return Scaffold(
        body: Center(
          child: Text(
            'Lỗi: ${detailState.error}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // Khi không tìm thấy dữ liệu
    if (detailState.itinerary == null) {
      return const Scaffold(
        body: Center(child: Text('Không tìm thấy dữ liệu hành trình')),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (final context, final innerBoxIsScrolled) => [
          HeroSection(itinerary: detailState.itinerary!),
          TabbarHeader(tabController: _tabController),
        ],
        body: TabbarContent(
          tabController: _tabController,
          itineraryId: detailState.itineraryId!,
        ),
      ),
    );
  }
}
