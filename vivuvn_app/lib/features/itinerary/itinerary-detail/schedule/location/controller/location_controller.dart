import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../service/location_service.dart';
import '../state/location_state.dart';

final locationControllerProvider =
    AutoDisposeNotifierProvider<LocationController, LocationState>(
      () => LocationController(),
    );

class LocationController extends AutoDisposeNotifier<LocationState> {
  @override
  LocationState build() => LocationState();

  Future<void> fetchLocationDetail(final int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await ref
          .read(locationServiceProvider)
          .getLocationDetail(id);
      state = state.copyWith(detail: data, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        error: DioExceptionHandler.handleException(e),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
