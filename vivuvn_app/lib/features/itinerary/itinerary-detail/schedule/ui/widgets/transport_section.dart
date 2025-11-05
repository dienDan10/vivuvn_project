import 'package:flutter/material.dart';

import '../../../../../../common/helper/time_util.dart';
import '../../model/itinerary_item.dart';
import 'select_transport_modal.dart';

class TransportSection extends StatelessWidget {
  final ItineraryItem item;

  const TransportSection({super.key, required this.item});

  void _showTransportOptions(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final BuildContext context) {
        return SelectTransportModal(item: item);
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Chọn icon theo vehicle
    final vehicleData = _getVehicleData(
      item.transportationVehicle,
      colorScheme,
    );
    final vehicleIcon = vehicleData['icon'] as IconData;
    final iconColor = vehicleData['color'] as Color;

    // Duration (giây → phút)
    final durationText = item.transportationDuration != null
        ? TimeUtil.secondToTimeText(item.transportationDuration!.ceil())
        : '-';

    // Distance (mét → km)
    final distanceText = item.transportationDistance != null
        ? '${(item.transportationDistance! / 1000).toStringAsFixed(1)} km'
        : '-';

    return Row(
      children: [
        InkWell(
          onTap: () => _showTransportOptions(context),
          child: Row(
            children: [
              Icon(vehicleIcon, color: iconColor, size: 20),
              const SizedBox(width: 5),
              Text(
                durationText,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              const Text('-', style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 5),
              Text(
                distanceText,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Icon(
                Icons.arrow_drop_down_sharp,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),
        ),
        const Expanded(child: Divider(thickness: 1)),
      ],
    );
  }

  Map<String, dynamic> _getVehicleData(
    final String? vehicle,
    final ColorScheme colorScheme,
  ) {
    final vehicleKey = vehicle?.toUpperCase();

    switch (vehicleKey) {
      case 'DRIVE':
        return {'icon': Icons.directions_car, 'color': colorScheme.primary};
      case 'WALK':
        return {'icon': Icons.directions_walk, 'color': colorScheme.tertiary};
      case 'TWO_WHEELER':
        return {'icon': Icons.two_wheeler, 'color': Colors.deepOrange};
      case 'TRANSIT':
        return {'icon': Icons.directions_transit, 'color': Colors.blue};
      default:
        return {
          'icon': Icons.directions,
          'color': colorScheme.onSurfaceVariant,
        };
    }
  }
}
