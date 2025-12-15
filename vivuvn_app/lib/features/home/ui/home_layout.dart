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

  @override
  void initState() {
    super.initState();
    // Load data once on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasLoadedInitial) {
        _hasLoadedInitial = true;
        ref.read(homeControllerProvider.notifier).loadHomeData();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when returning to screen (controller tự throttle)
    if (_hasLoadedInitial) {
      ref.read(homeControllerProvider.notifier).refreshIfStale();
    }
  }

  @override
  Widget build(final BuildContext context) {
    final homeState = ref.watch(homeControllerProvider);

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
