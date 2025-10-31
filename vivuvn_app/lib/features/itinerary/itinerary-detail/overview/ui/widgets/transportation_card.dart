import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../detail/controller/itinerary_detail_controller.dart';

/// Widget hiển thị và chỉnh sửa phương tiện di chuyển
class TransportationCard extends ConsumerWidget {
  const TransportationCard({super.key});

  IconData _getTransportIcon(final String vehicle) {
    final lowerVehicle = vehicle.toLowerCase();
    if (lowerVehicle.contains('máy bay') || lowerVehicle.contains('plane')) {
      return Icons.flight;
    } else if (lowerVehicle.contains('ô tô') || lowerVehicle.contains('car')) {
      return Icons.directions_car;
    } else if (lowerVehicle.contains('tàu') || lowerVehicle.contains('train')) {
      return Icons.train;
    } else if (lowerVehicle.contains('xe khách') ||
        lowerVehicle.contains('bus')) {
      return Icons.directions_bus;
    } else if (lowerVehicle.contains('xe máy') ||
        lowerVehicle.contains('motor')) {
      return Icons.two_wheeler;
    } else if (lowerVehicle.contains('đi bộ') ||
        lowerVehicle.contains('walk')) {
      return Icons.directions_walk;
    }
    return Icons.directions_car; // Default icon
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final itineraryState = ref.watch(itineraryDetailControllerProvider);
    final itinerary = itineraryState.itinerary;

    // Không hiển thị gì nếu chưa có dữ liệu
    if (itinerary == null) {
      return const SizedBox.shrink();
    }

    final vehicle = itinerary.transportationVehicle.isEmpty
        ? 'Chưa xác định'
        : itinerary.transportationVehicle;
    final icon = _getTransportIcon(vehicle);

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 6,
              bottom: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A5B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 24, color: const Color(0xFFFF8A5B)),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phương tiện di chuyển',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vehicle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: itinerary.transportationVehicle.isEmpty
                        ? Colors.grey.shade500
                        : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Edit button (placeholder for future CRUD)
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              size: 20,
              color: Colors.grey.shade600,
            ),
            onPressed: () {
              // TODO: Implement edit transportation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng chỉnh sửa sẽ được thêm sau'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
