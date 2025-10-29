import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';

class TransportSection extends ConsumerWidget {
  final int index; // index của item trong ngày

  const TransportSection({super.key, required this.index});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(itineraryScheduleControllerProvider);
    final selectedDay =
        (state.days.isNotEmpty && state.selectedIndex < state.days.length)
        ? state.days[state.selectedIndex]
        : null;

    if (selectedDay == null) return const SizedBox();
    if (index >= selectedDay.items.length - 1) return const SizedBox();

    final nextItem = selectedDay.items[index + 1];

    // Chọn icon theo vehicle
    IconData vehicleIcon;
    Color iconColor;
    switch (nextItem.transportationVehicle?.toUpperCase()) {
      case 'DRIVE':
        vehicleIcon = Icons.directions_car;
        iconColor = Colors.blue;
        break;
      case 'WALK':
        vehicleIcon = Icons.directions_walk;
        iconColor = Colors.green;
        break;
      case 'FLIGHT':
        vehicleIcon = Icons.flight;
        iconColor = Colors.red;
        break;
      case 'BIKE':
        vehicleIcon = Icons.directions_bike;
        iconColor = Colors.orange;
        break;
      default:
        vehicleIcon = Icons.directions;
        iconColor = Colors.grey;
    }

    // Duration (giây → phút)
    final durationText = nextItem.transportationDuration != null
        ? '${(nextItem.transportationDuration! / 60).ceil()} phút'
        : '-';

    // Distance (mét → km)
    final distanceText = nextItem.transportationDistance != null
        ? '${(nextItem.transportationDistance! / 1000).toStringAsFixed(1)} km'
        : '-';

    return Row(
      children: [
        Icon(vehicleIcon, color: iconColor, size: 20),
        const SizedBox(width: 6),
        Text(durationText, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        const Text('–', style: TextStyle(color: Colors.grey)),
        const SizedBox(width: 6),
        Text(distanceText, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
