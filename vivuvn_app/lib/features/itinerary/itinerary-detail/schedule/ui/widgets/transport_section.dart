import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';

class TransportSection extends ConsumerWidget {
  const TransportSection({super.key, this.index});

  final int? index;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(itineraryScheduleControllerProvider);
    final selectedDay =
        (state.days.isNotEmpty && state.selectedIndex < state.days.length)
        ? state.days[state.selectedIndex]
        : null;

    if (selectedDay == null || selectedDay.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentItemIndex = index ?? 0;
    if (currentItemIndex >= selectedDay.items.length - 1) {
      return const SizedBox.shrink();
    }

    final currentItem = selectedDay.items[currentItemIndex];
    final transport = currentItem.transportationVehicle ?? 'WALK';
    final distance = currentItem.transportationDistance ?? 0;
    final duration = currentItem.transportationDuration ?? 0;

    // Định dạng dữ liệu hiển thị
    final vehicleIcon = _getVehicleIcon(transport);
    final vehicleLabel = _getVehicleLabel(transport);
    final distanceKm = distance >= 1000
        ? '${(distance / 1000).toStringAsFixed(1)} km'
        : '$distance m';
    final durationMin = '${(duration / 60).round()} phút';

    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Căn chỉnh icon với text
          Transform.translate(
            offset: const Offset(0, -5),
            child: Text(vehicleIcon, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 6),
          // Nội dung mô tả hành trình
          Expanded(
            child: Text(
              '$vehicleLabel • $distanceKm • $durationMin',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _getVehicleIcon(final String transport) {
    switch (transport.toUpperCase()) {
      case 'DRIVE':
        return '🚗';
      case 'WALK':
        return '🚶‍♂️';
      case 'BIKE':
        return '🚴‍♂️';
      case 'BUS':
        return '🚌';
      default:
        return '🚗';
    }
  }

  String _getVehicleLabel(final String transport) {
    switch (transport.toUpperCase()) {
      case 'DRIVE':
        return 'Drive';
      case 'WALK':
        return 'Walk';
      case 'BIKE':
        return 'Bike';
      case 'BUS':
        return 'Bus';
      default:
        return 'Drive';
    }
  }
}
