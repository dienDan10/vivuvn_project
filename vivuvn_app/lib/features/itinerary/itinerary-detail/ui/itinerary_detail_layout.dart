import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/helper/app_constants.dart';
import '../controller/itinerary_detail_controller.dart';
import 'hero_section.dart';
import 'tabbar_content.dart';
import 'tabbar_header.dart';

class ItineraryDetailLayout extends ConsumerStatefulWidget {
  final int itineraryId;
  const ItineraryDetailLayout({super.key, required this.itineraryId});

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

    Future.microtask(() {
      ref
          .read(itineraryDetailControllerProvider.notifier)
          .setItineraryId(widget.itineraryId);
    });

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

    // Nếu chưa có ID hoặc chưa có data thì loading
    if (detailState.itineraryId == null ||
        detailState.itinerary == null ||
        detailState.isLoading) {
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
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (final context, final innerBoxIsScrolled) => [
          HeroSection(itinerary: detailState.itinerary!),
          TabbarHeader(tabController: _tabController),
        ],
        body: Column(
          children: [
            Expanded(
              child: TabbarContent(
                tabController: _tabController,
                itineraryId: widget.itineraryId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
