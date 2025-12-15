import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/itinerary/itinerary-detail/detail/controller/itinerary_detail_controller.dart';
import '../features/itinerary/itinerary-detail/detail/ui/itinerary_detail_layout.dart';

class ItineraryDetailScreen extends ConsumerStatefulWidget {
  final int itineraryId;
  const ItineraryDetailScreen({super.key, required this.itineraryId});

  @override
  ConsumerState<ItineraryDetailScreen> createState() =>
      _ItineraryDetailScreenState();
}

class _ItineraryDetailScreenState extends ConsumerState<ItineraryDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Set the itinerary ID trong addPostFrameCallback để tránh modify provider trong build phase
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait a bit to ensure any setItineraryData calls have completed
      // Use multiple microtasks to ensure state propagation
      await Future.delayed(Duration.zero);
      await Future.delayed(Duration.zero);
      
      final controller = ref.read(itineraryDetailControllerProvider.notifier);
      final currentState = ref.read(itineraryDetailControllerProvider);
      
      // If itinerary data is already set (e.g., from ItineraryCard), don't call setItineraryId
      // to avoid triggering duplicate fetch
      if (currentState.itinerary != null && 
          currentState.itinerary!.id == widget.itineraryId) {
        // If itineraryId is also already set, we're good
        if (currentState.itineraryId == widget.itineraryId) {
          return;
        }
        // If itinerary is set but itineraryId is not, just set itineraryId without triggering fetch
        controller.setItineraryId(widget.itineraryId);
        return;
      }
      
      // If itineraryId is already set to the same value, skip
      if (currentState.itineraryId == widget.itineraryId) {
        return;
      }
      
      controller.setItineraryId(widget.itineraryId);
    });
  }

  @override
  Widget build(final BuildContext context) {
    return const ItineraryDetailLayout();
  }
}
