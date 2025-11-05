import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/hotels_controller.dart';

class HotelModalSaveButton extends ConsumerWidget {
  const HotelModalSaveButton({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final formState = ref.watch(hotelsControllerProvider);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: formState.formIsValid
            ? () => _handleSave(context, ref)
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Thêm'),
      ),
    );
  }

  Future<void> _handleSave(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final formState = ref.read(hotelsControllerProvider);

    if (formState.formDisplayName.isEmpty) return;

    // Add new hotel — requires googlePlaceId and date values
    final googlePlaceId = formState.formSelectedLocation?.googlePlaceId;
    if (googlePlaceId == null) return;

    final success = await ref
        .read(hotelsControllerProvider.notifier)
        .addHotel(
          googlePlaceId: googlePlaceId,
          checkInDate: formState.formCheckInDate ?? DateTime.now(),
          checkOutDate:
              formState.formCheckOutDate ??
              formState.formCheckInDate ??
              DateTime.now(),
        );

    if (success) {
      // Clear form state so the name field is reset
      ref.read(hotelsControllerProvider.notifier).initializeForm();
      if (context.mounted) Navigator.pop(context);
    }
  }
}
