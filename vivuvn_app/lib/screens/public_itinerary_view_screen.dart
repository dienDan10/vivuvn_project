import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/public_itinerary/controller/public_itinerary_controller.dart';
import '../features/public_itinerary/ui/public_itinerary_layout.dart';

class PublicItineraryViewScreen extends ConsumerStatefulWidget {
  final String itineraryId;

  const PublicItineraryViewScreen({
    required this.itineraryId,
    super.key,
  });

  @override
  ConsumerState<PublicItineraryViewScreen> createState() =>
      _PublicItineraryViewScreenState();
}

class _PublicItineraryViewScreenState
    extends ConsumerState<PublicItineraryViewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(publicItineraryControllerProvider.notifier)
        ..setItineraryId(widget.itineraryId)
        ..loadItineraryDetail();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(publicItineraryControllerProvider);

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lịch trình')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return _PublicItineraryError(
        error: state.error!,
        onRetry: () =>
            ref.read(publicItineraryControllerProvider.notifier).loadItineraryDetail(),
      );
    }

    if (state.itinerary == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lịch trình')),
        body: const Center(child: Text('Không tìm thấy lịch trình')),
      );
    }

    return PublicItineraryLayout(
      state: state,
      onRetry: () =>
          ref.read(publicItineraryControllerProvider.notifier).loadItineraryDetail(),
      onBack: () => Navigator.of(context).pop(),
    );
  }
}

class _PublicItineraryError extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _PublicItineraryError({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch trình')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lỗi: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

