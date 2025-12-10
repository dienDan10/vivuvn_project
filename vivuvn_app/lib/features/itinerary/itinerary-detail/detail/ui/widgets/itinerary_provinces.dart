import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_detail_controller.dart';

class ItineraryProvinces extends ConsumerWidget {
  const ItineraryProvinces({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final startProvinceName = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary?.startProvinceName,
      ),
    );
    final destinationProvinceName = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary?.destinationProvinceName,
      ),
    );

    if (startProvinceName == null || destinationProvinceName == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Điểm đi
          Row(
            children: [
              const Icon(
                Icons.place,
                size: 16,
                color: Colors.white70,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  startProvinceName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // Mũi tên chỉ hướng
          const Padding(
            padding: EdgeInsets.only(top: 2, bottom: 2),
            child: Row(
              children: [
                SizedBox(
                  width: 16, // Width bằng với icon size để căn giữa
                  child: Icon(
                    Icons.arrow_downward,
                    size: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Điểm đến
          Row(
            children: [
              const Icon(
                Icons.place,
                size: 16,
                color: Colors.white70,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  destinationProvinceName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

