import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_snap/sliver_snap.dart';

import '../../../../../common/helper/app_constants.dart';
import '../../budget/ui/budget_tab.dart';
import '../../member/ui/member_tab.dart';
import '../../overview/ui/overview_tab_layout.dart';
import '../../schedule/controller/automically_generate_by_ai_controller.dart';
import '../../schedule/ui/schedule_tab.dart';
import '../controller/itinerary_detail_controller.dart';
import '../state/itinerary_detail_state.dart';
import 'collapsed_appbar.dart';
import 'expanded_appbar_background.dart';
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

  late ProviderSubscription<ItineraryDetailState> _itineraryListener;
  // Track the last itineraryId that triggered a fetch to prevent duplicate triggers
  int? _lastFetchedItineraryId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    //_registerScrollListener();
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
        // If itineraryId didn't change, skip
        if (previous?.itineraryId == next.itineraryId) {
          return;
        }

        // If itineraryId is null, skip
        if (next.itineraryId == null) {
          return;
        }

        // If itinerary is already loaded and matches the ID, skip fetch
        // Check this BEFORE checking _lastFetchedItineraryId to handle the case
        // where setItineraryData was called before setItineraryId
        if (next.itinerary != null && next.itinerary!.id == next.itineraryId) {
          _lastFetchedItineraryId = next.itineraryId;
          return;
        }

        // If we've already triggered a fetch for this ID, skip
        if (next.itineraryId == _lastFetchedItineraryId) {
          return;
        }

        // Otherwise, trigger fetch
        _lastFetchedItineraryId = next.itineraryId;
        ref
            .read(itineraryDetailControllerProvider.notifier)
            .fetchItineraryDetail();
      },
    );
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
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }

    if (detailState.itinerary == null) {
      return const Scaffold(
        body: Center(child: Text('Không tìm thấy dữ liệu hành trình')),
      );
    }

    return AnimatedBuilder(
      animation: _tabController,
      builder: (final context, final child) {
        return Scaffold(
          body: _buildBody(),
          floatingActionButtonLocation: ExpandableFab.location,
        );
      },
    );
  }

  Widget _buildBody() {
    if (_tabController.index == 0) {
      return _buildOverviewTab();
    } else {
      return _buildOtherTabs();
    }
  }

  Widget _buildOverviewTab() {
    return SliverSnap(
      scrollController: _scrollController,
      expandedContent: const ExpandedAppbarBackground(),
      expandedContentHeight: appbarExpandedHeight,
      collapsedContent: const Column(children: [CollapsedAppbar()]),
      collapsedBarHeight: const Size.fromHeight(kToolbarHeight).height,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: TabbarHeader(tabController: _tabController),
      ),
      body: const OverviewTabLayout(),
    );
  }

  Widget _buildOtherTabs() {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          const CollapsedAppbar(),
          TabbarHeader(tabController: _tabController),
          Expanded(
            child: _tabController.index == 1
                ? const ScheduleTab()
                : _tabController.index == 2
                ? const BudgetTab()
                : const MemberTab(),
          ),
        ],
      ),
    );
  }
}
