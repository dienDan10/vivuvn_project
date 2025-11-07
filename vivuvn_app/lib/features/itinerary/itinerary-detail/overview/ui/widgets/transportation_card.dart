import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../detail/controller/itinerary_detail_controller.dart';
import '../../../schedule/model/transportation_mode.dart';
import 'transportation_selection_bottom_sheet.dart';

/// Widget hiển thị và chỉnh sửa phương tiện di chuyển
class TransportationCard extends ConsumerWidget {
  const TransportationCard({super.key});

  IconData _getTransportIcon(final String vehicle) {
    return TransportationMode.getIcon(vehicle);
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final itinerary = ref.watch(
      itineraryDetailControllerProvider.select((final state) => state.itinerary),
    );

    // Không hiển thị gì nếu chưa có dữ liệu
    if (itinerary == null) {
      return const SizedBox.shrink();
    }

    final activeVehicle = ref.watch(
      itineraryDetailControllerProvider.select((final state) {
        final draft = state.transportationVehicleDraft;
        final itineraryVehicle = state.itinerary?.transportationVehicle ?? '';
        final effective = (draft != null && draft.isNotEmpty)
            ? draft
            : itineraryVehicle;
        if (effective.isEmpty) {
          return null;
        }
        return TransportationMode.normalizeLabel(effective);
      }),
    );

    final vehicleLabel = activeVehicle ?? 'Chưa xác định';
    final icon = _getTransportIcon(vehicleLabel);

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
              color: const Color(0xFFFF8A5B).withValues(alpha: 0.1),
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
                  vehicleLabel,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: activeVehicle == null
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
              ref
                  .read(itineraryDetailControllerProvider.notifier)
                  .startTransportationSelection();
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (final _) => const TransportationSelectionBottomSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}
