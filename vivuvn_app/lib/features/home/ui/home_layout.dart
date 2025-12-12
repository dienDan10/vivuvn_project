import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/home_controller.dart';
import '../state/home_state.dart';
import 'widgets/destination_section.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/itinerary_section.dart';
import 'widgets/travel_tips_hardcoded_section.dart';

class HomeLayout extends ConsumerStatefulWidget {
  const HomeLayout({super.key});

  @override
  ConsumerState<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends ConsumerState<HomeLayout> {
  bool _hasLoadedInitial = false;
  DateTime? _lastRefreshTime;

  void _refreshSilently() {
    final homeState = ref.read(homeControllerProvider);
    // Only refresh if we have data (not initial or error state)
    if (homeState.isLoaded || (!homeState.isEmpty && homeState.status != HomeStatus.initial)) {
      // Throttle: chỉ refresh nếu đã qua ít nhất 1 giây kể từ lần refresh cuối
      final now = DateTime.now();
      if (_lastRefreshTime == null || 
          now.difference(_lastRefreshTime!).inSeconds >= 1) {
        _lastRefreshTime = now;
        Future.microtask(() {
          ref.read(homeControllerProvider.notifier).refreshHomeDataSilently();
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh silently when returning to this screen (after first load)
    if (_hasLoadedInitial) {
      _refreshSilently();
    }
  }

  @override
  Widget build(final BuildContext context) {
    final homeState = ref.watch(homeControllerProvider);

    // Load data on first build if initial
    if (homeState.status == HomeStatus.initial && !_hasLoadedInitial) {
      _hasLoadedInitial = true;
      Future.microtask(() {
        ref.read(homeControllerProvider.notifier).loadHomeData();
      });
    }

    // Refresh silently every time widget is rebuilt (after initial load)
    // This ensures data is refreshed when returning to home tab
    // Throttle is handled in _refreshSilently() to avoid too many refreshes
    if (_hasLoadedInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _refreshSilently();
        }
      });
    }

    return Scaffold(body: _buildBody(context, ref, homeState));
  }

  Widget _buildBody(
    final BuildContext context,
    final WidgetRef ref,
    final HomeState state,
  ) {
    if (state.isLoading && state.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Đã có lỗi xảy ra: ${state.errorMessage ?? "Unknown error"}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(homeControllerProvider.notifier).refreshHomeData();
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(homeControllerProvider.notifier).refreshHomeData();
      },
      child: const CustomScrollView(
        slivers: [
          HomeAppBar(),

          // Destinations section
          SliverToBoxAdapter(
            child: DestinationSection(),
          ),

          // Itineraries section
          SliverToBoxAdapter(
            child: ItinerarySection(),
          ),

          // Travel tips section
          SliverToBoxAdapter(child: TravelTipsHardcodedSection()),

          SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
