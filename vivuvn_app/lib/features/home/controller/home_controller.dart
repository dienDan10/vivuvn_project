import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/remote/exception/dio_exception_handler.dart';
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
    } on DioException catch (e) {
      final message = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: message,
      );
      debugPrint('Error loading home data: $message');
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

