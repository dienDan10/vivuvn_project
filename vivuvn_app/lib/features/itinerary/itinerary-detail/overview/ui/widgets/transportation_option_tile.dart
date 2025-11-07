import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../detail/controller/itinerary_detail_controller.dart';
import '../../../schedule/model/transportation_mode.dart';

class TransportationOptionTile extends ConsumerWidget {
  const TransportationOptionTile({super.key, required this.mode});

  final String mode;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedVehicle = ref.watch(
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

    final isSelected = selectedVehicle != null &&
        TransportationMode.equalsIgnoreCase(selectedVehicle, mode);
    final colorScheme = theme.colorScheme;
    final icon = TransportationMode.getIcon(mode);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(
            alpha: isSelected ? 0.3 : 0.1,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),
      title: Text(
        mode,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing:
          isSelected ? Icon(Icons.check_circle, color: colorScheme.primary) : null,
      onTap: () {
        ref
            .read(itineraryDetailControllerProvider.notifier)
            .setTransportationVehicleDraft(mode);
        Navigator.of(context).pop();
      },
    );
  }
}

