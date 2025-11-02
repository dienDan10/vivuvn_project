import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/helper/app_constants.dart';
import '../../../../../../common/toast/global_toast.dart';
import '../../controller/itinerary_schedule_controller.dart';
import '../../model/itinerary_item.dart';

class SelectTransportModal extends ConsumerStatefulWidget {
  final ItineraryItem item;

  const SelectTransportModal({super.key, required this.item});

  @override
  ConsumerState<SelectTransportModal> createState() =>
      _SelectTransportModalState();
}

class _SelectTransportModalState extends ConsumerState<SelectTransportModal> {
  String? _selectedVehicle;

  void _updateTransportationVehicle(final String vehicle) async {
    setState(() {
      _selectedVehicle = vehicle;
    });

    await ref
        .read(itineraryScheduleControllerProvider.notifier)
        .updateTransportationVehicle(
          itemId: widget.item.itineraryItemId,
          vehicle: vehicle,
        );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = ref.watch(
      itineraryScheduleControllerProvider.select(
        (final state) => state.isLoadingUpdateTransportation,
      ),
    );

    ref.listen(
      itineraryScheduleControllerProvider.select(
        (final state) => state.updateTransportationError,
      ),
      (final previous, final next) {
        if (next != null && mounted) {
          GlobalToast.showErrorToast(context, message: next);
        }
      },
    );

    return PopScope(
      canPop: !isLoading,
      child: Container(
        padding: const EdgeInsets.only(bottom: 20, top: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    isLoading ? 'Đang cập nhật...' : 'Chọn phương tiện',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      ),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                ],
              ),
            ),
            const Divider(),

            // Loading overlay or transport options
            if (isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Đang cập nhật phương tiện...',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else
              // Transport options
              ...travelModeLabels.entries.map((final entry) {
                final vehicleData = _getVehicleData(entry.key, colorScheme);
                return _buildTransportOption(
                  context: context,
                  icon: vehicleData['icon'] as IconData,
                  label: entry.value,
                  value: entry.key,
                  color: vehicleData['color'] as Color,
                  isSelected:
                      widget.item.transportationVehicle?.toUpperCase() ==
                      entry.key,
                  isUpdating: _selectedVehicle == entry.key,
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportOption({
    required final BuildContext context,
    required final IconData icon,
    required final String label,
    required final String value,
    required final Color color,
    required final bool isSelected,
    required final bool isUpdating,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      enabled: !isUpdating,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isUpdating
              ? colorScheme.onSurfaceVariant
              : colorScheme.onSurface,
        ),
      ),
      trailing: isUpdating
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            )
          : isSelected
          ? Icon(Icons.check_circle, color: colorScheme.primary)
          : null,
      onTap: isUpdating ? null : () => _updateTransportationVehicle(value),
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
