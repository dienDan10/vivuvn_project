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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(itineraryDetailControllerProvider.notifier)
          .setItineraryId(widget.itineraryId);
    });
  }

  @override
  Widget build(final BuildContext context) {
    return const ItineraryDetailLayout();
  }
}
