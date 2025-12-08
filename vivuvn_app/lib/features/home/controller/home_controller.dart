import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/home_service.dart';
import '../service/home_service_impl.dart';
import '../state/home_state.dart';

// State notifier for home data
class HomeController extends StateNotifier<HomeState> {
  final HomeService _service;

  HomeController(this._service) : super(const HomeState());

  Future<void> loadHomeData() async {
    if (state.isLoading) return;

    state = state.copyWith(status: HomeStatus.loading);

    try {
      final destinations = await _service.getPopularDestinations();
      final itineraries = await _service.getPublicItineraries();

      state = state.copyWith(
        status: HomeStatus.loaded,
        destinations: destinations,
        itineraries: itineraries,
      );
    } catch (e) {
      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      );
      debugPrint('Error loading home data: $e');
    }
  }

  Future<void> refreshHomeData() async {
    state = const HomeState();
    await loadHomeData();
  }
}

// Controller provider
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (final ref) {
    final service = ref.watch(homeServiceProvider);
    return HomeController(service);
  },
);

// PageController for itinerary carousel
final itineraryPageControllerProvider = Provider.autoDispose<PageController>((
  final ref,
) {
  final controller = PageController(viewportFraction: 0.9, initialPage: 0);

  ref.onDispose(() {
    controller.dispose();
  });

  return controller;
});

// Auto-scroll state provider
class AutoScrollController extends StateNotifier<bool> {
  Timer? _timer;
  final PageController _pageController;
  int _totalCount = 0;

  AutoScrollController(this._pageController) : super(false);

  void start({final int totalCount = 0}) {
    if (state) return; // Already started

    _totalCount = totalCount;
    state = true;
    _timer = Timer.periodic(const Duration(seconds: 4), (final timer) {
      if (_pageController.hasClients) {
        final currentPage = _pageController.page?.toInt() ?? 0;
        final nextPage = _totalCount > 0 && currentPage >= _totalCount - 1
            ? 0
            : currentPage + 1;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    state = false;
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}

// Auto-scroll controller provider
final autoScrollControllerProvider =
    StateNotifierProvider.autoDispose<AutoScrollController, bool>((final ref) {
      final pageController = ref.watch(itineraryPageControllerProvider);
      final controller = AutoScrollController(pageController);

      ref.onDispose(() {
        controller.stop();
      });

      return controller;
    });
