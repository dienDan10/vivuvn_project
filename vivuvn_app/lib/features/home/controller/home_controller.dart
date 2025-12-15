import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../../core/routes/routes.dart';
import '../../itinerary/itinerary-detail/detail/controller/itinerary_detail_controller.dart';
import '../../itinerary/itinerary-detail/detail/service/itinerary_detail_service.dart';
import '../data/dto/itinerary_dto.dart';
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
    } catch (e) {
      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshHomeData() async {
    state = const HomeState();
    await loadHomeData();
  }

  /// Refresh data silently without showing loading indicator
  /// Used when returning to home screen
  Future<void> refreshHomeDataSilently() async {
    // Don't refresh if already loading
    if (state.isLoading) return;
    
    // Keep current data and status, just refresh in background
    try {
      final destinations = await _service.getPopularDestinations();
      final itineraries = await _service.getPublicItineraries();

      state = state.copyWith(
        status: HomeStatus.loaded,
        destinations: destinations,
        itineraries: itineraries,
        errorMessage: null, // Clear any previous errors
      );
    } on DioException catch (e) {
      final message = DioExceptionHandler.handleException(e);
      // Only update error if we have data, otherwise keep showing data
      if (state.isEmpty) {
        state = state.copyWith(
          status: HomeStatus.error,
          errorMessage: message,
        );
      }
      // If we have data, keep showing it even if refresh fails
    } catch (e) {
      // Only update error if we have data, otherwise keep showing data
      if (state.isEmpty) {
        state = state.copyWith(
          status: HomeStatus.error,
          errorMessage: e.toString(),
        );
      }
      // If we have data, keep showing it even if refresh fails
    }
  }

  /// Handle tap on itinerary card - fetch detail and navigate based on isMember
  Future<void> handleItineraryTap(
    final BuildContext context,
    final WidgetRef ref,
    final ItineraryDto itinerary,
  ) async {
    final itineraryId = int.tryParse(itinerary.id);
    
    if (itineraryId == null) {
      return;
    }

    // Fetch detail first to get accurate isMember status
    try {
      final detailService = ref.read(itineraryDetailServiceProvider);
      final detail = await detailService.getItineraryDetail(itineraryId);
      
      // Check isMember from detail response
      if (detail.isOwner || detail.isMember) {
        // Pre-set the itinerary data in controller to avoid duplicate fetch
        final controller = ref.read(itineraryDetailControllerProvider.notifier);
        controller.setItineraryData(detail);
        
        // Wait a bit to ensure state is updated before navigation
        await Future.delayed(const Duration(milliseconds: 50));
        
        if (context.mounted) {
          context.push(createItineraryDetailRoute(itineraryId));
        }
      } else {
        // If not a member, navigate to public itinerary view
        if (context.mounted) {
          context.push(createPublicItineraryViewRoute(itinerary.id));
        }
      }
    } catch (e) {
      // If fetch fails, navigate to public view as fallback
      if (context.mounted) {
        context.push(createPublicItineraryViewRoute(itinerary.id));
      }
    }
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

