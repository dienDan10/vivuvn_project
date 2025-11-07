import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../detail/controller/itinerary_detail_controller.dart';
import '../../../schedule/model/transportation_mode.dart';
import 'transportation_option_tile.dart';

class TransportationSelectionBottomSheet extends ConsumerWidget {
  const TransportationSelectionBottomSheet({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);

    final hasSelection = ref.watch(
      itineraryDetailControllerProvider.select((final state) {
        final draft = state.transportationVehicleDraft;
        final itineraryVehicle = state.itinerary?.transportationVehicle ?? '';
        return (draft != null && draft.isNotEmpty) || itineraryVehicle.isNotEmpty;
      }),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.only(bottom: 12),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Chọn phương tiện',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: TransportationMode.all.length,
                itemBuilder: (final context, final index) {
                  final mode = TransportationMode.all[index];
                  return TransportationOptionTile(mode: mode);
                },
              ),
            ),
            if (!hasSelection)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Chưa có phương tiện được chọn',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

