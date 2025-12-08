import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/home_controller.dart';
import '../state/home_state.dart';
import 'widgets/destination_section.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/itinerary_section.dart';
import 'widgets/travel_tips_hardcoded_section.dart';

class HomeLayout extends ConsumerWidget {
  const HomeLayout({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);

    // Load data on first build if initial
    if (homeState.status == HomeStatus.initial) {
      Future.microtask(() {
        ref.read(homeControllerProvider.notifier).loadHomeData();
      });
    }

    // Start auto-scroll when data is loaded
    ref.listen<HomeState>(homeControllerProvider, (final previous, final next) {
      if (next.isLoaded && !ref.read(autoScrollControllerProvider)) {
        ref.read(autoScrollControllerProvider.notifier).start();
      }
    });

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
      child: CustomScrollView(
        slivers: [
          const HomeAppBar(),

          // Destinations section
          SliverToBoxAdapter(
            child: DestinationSection(destinations: state.destinations),
          ),

          // Itineraries section
          SliverToBoxAdapter(
            child: ItinerarySection(itineraries: state.itineraries),
          ),

          // Travel tips section
          const SliverToBoxAdapter(child: TravelTipsHardcodedSection()),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
