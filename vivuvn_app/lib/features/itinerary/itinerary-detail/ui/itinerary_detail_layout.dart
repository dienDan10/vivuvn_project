import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/helper/app_constants.dart';
import '../controller/itinerary_detail_controller.dart';
import '../schedule/controller/automically_generate_by_ai_controller.dart';
import '../state/itinerary_detail_state.dart';
import 'budget_header_persistent.dart';
import 'day_selector_persistent.dart';
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
  bool _isHeroCollapsed = false;

  late ProviderSubscription<ItineraryDetailState> _itineraryListener;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _registerScrollListener();
    _setupItineraryListener();
    _setupAiTabSwitchListener();
  }

  void _setupAiTabSwitchListener() {
    // Listen for tab switch requests from AI generation flow.
    // When controller sets aiTabSwitchProvider to 0, animate to PlaceList tab
    // and reload itinerary data.
    ref.listenManual<int?>(aiTabSwitchProvider, (final previous, final next) {
      if (next != null) {
        // Animate to requested tab (0 = PlaceList)
        _tabController.animateTo(next);

        // Reload itinerary detail to fetch updated data after generation
        ref
            .read(itineraryDetailControllerProvider.notifier)
            .fetchItineraryDetail();

        // Clear the request so future requests can be issued
        ref.read(aiTabSwitchProvider.notifier).state = null;
      }
    });
  }

  void _setupItineraryListener() {
    _itineraryListener = ref.listenManual<ItineraryDetailState>(
      itineraryDetailControllerProvider,
      (final previous, final next) {
        if (previous?.itineraryId != next.itineraryId &&
            next.itineraryId != null) {
          ref
              .read(itineraryDetailControllerProvider.notifier)
              .fetchItineraryDetail();
        }
      },
    );
  }

  void _registerScrollListener() {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging && _tabController.index != 0) {
        _scrollController.animateTo(
          appbarExpandedHeight -
              (kToolbarHeight + MediaQuery.of(context).padding.top),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );

        _isHeroCollapsed = true;
      } else if (_tabController.indexIsChanging && _tabController.index == 0) {
        // Reset when returning to Overview tab
        _isHeroCollapsed = false;
      }

      // Listen to scroll position to prevent scrolling back up
      _scrollController.addListener(() {
        if (_tabController.index != 0 && _isHeroCollapsed) {
          final collapsePoint =
              appbarExpandedHeight -
              (kToolbarHeight + MediaQuery.of(context).padding.top);

          // Prevent scrolling above the collapse point
          if (_scrollController.offset < collapsePoint) {
            _scrollController.jumpTo(collapsePoint);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    _itineraryListener.close();

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final detailState = ref.watch(itineraryDetailControllerProvider);

    if (detailState.itineraryId == null || detailState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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

    if (detailState.itinerary == null) {
      return const Scaffold(
        body: Center(child: Text('Không tìm thấy dữ liệu hành trình')),
      );
    }

    return Scaffold(
      body: AnimatedBuilder(
        animation: _tabController,
        builder: (final context, final child) {
          return NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (final context, final innerBoxIsScrolled) => [
              HeroSection(itinerary: detailState.itinerary!),
              TabbarHeader(tabController: _tabController),

              // Add DaySelectorBar only when Schedule tab is active
              if (_tabController.index == 1) const DaySelectorPersistent(),

              if (_tabController.index == 2) const BudgetHeaderPersistent(),
            ],
            body: TabbarContent(tabController: _tabController),
          );
        },
      ),
    );
  }
}
