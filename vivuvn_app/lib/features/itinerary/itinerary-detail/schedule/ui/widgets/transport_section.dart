import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/itinerary_item.dart';

class TransportSection extends ConsumerWidget {
  final ItineraryItem item;

  const TransportSection({super.key, required this.item});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Chọn icon theo vehicle
    IconData vehicleIcon;
    Color iconColor;
    switch (item.transportationVehicle?.toUpperCase()) {
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
    final durationText = item.transportationDuration != null
        ? '${(item.transportationDuration! / 60).ceil()} phút'
        : '-';

    // Distance (mét → km)
    final distanceText = item.transportationDistance != null
        ? '${(item.transportationDistance! / 1000).toStringAsFixed(1)} km'
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
        const SizedBox(width: 6),
        const Expanded(child: Divider(thickness: 1)),
      ],
    );
  }
}
