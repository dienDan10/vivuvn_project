import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/helper/app_constants.dart';
import '../controller/itinerary_detail_controller.dart';
import '../state/itinerary_detail_state.dart';
import 'budget_header_persistent_header.dart';
import 'day_selector_persistent_header.dart';
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

  late ProviderSubscription<ItineraryDetailState> _itineraryListener;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _registerScrollListener();
    _setupItineraryListener();
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
      }

      // Rebuild to show/hide DaySelectorBar
      if (mounted) {
        setState(() {});
      }
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
              if (_tabController.index == 1)
                const DaySelectorPersistentHeader(),

              // Add Budget headers only when Budget tab is active
              if (_tabController.index == 2)
                const BudgetHeaderPersistentHeader(),
            ],
            body: TabbarContent(tabController: _tabController),
          );
        },
      ),
    );
  }
}
