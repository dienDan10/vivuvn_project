import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/image_timeout_state.dart';

/// Controller for managing image loading timeout
class ImageTimeoutController extends StateNotifier<ImageTimeoutState> {
  Timer? _timer;

  ImageTimeoutController() : super(const ImageTimeoutState());

  void startTimeout(final Duration duration) {
    _timer?.cancel();
    _timer = Timer(duration, () {
      if (mounted) {
        state = state.copyWith(timedOut: true);
      }
    });
  }

  void cancelTimeout() {
    _timer?.cancel();
  }

  void reset() {
    _timer?.cancel();
    state = const ImageTimeoutState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Provider family for image timeout controller (per image URL)
final imageTimeoutControllerProvider = StateNotifierProvider.family
    .autoDispose<ImageTimeoutController, ImageTimeoutState, String>(
      (final ref, final imageUrl) => ImageTimeoutController(),
    );
