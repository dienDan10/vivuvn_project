import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/hotels_controller.dart';
import 'hotel_checkin_picker.dart';
import 'hotel_checkout_picker.dart';
import 'hotel_modal_save_button.dart';
import 'hotel_search_field.dart';

class AddHotelModal extends ConsumerStatefulWidget {
  const AddHotelModal({super.key});

  @override
  ConsumerState<AddHotelModal> createState() => _AddHotelModalState();
}

class _AddHotelModalState extends ConsumerState<AddHotelModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(hotelsControllerProvider.notifier).initializeForm();
    });
  }

  @override
  Widget build(final BuildContext context) {
    ref.watch(hotelsControllerProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (final context, final scrollController) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Thêm khách sạn',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search field
            const HotelSearchField(),
            const SizedBox(height: 16),

            // Date pickers
            const Row(
              children: [
                Expanded(child: HotelCheckinPicker()),
                SizedBox(width: 12),
                Expanded(child: HotelCheckoutPicker()),
              ],
            ),
            const SizedBox(height: 24),

            // Save button
            const HotelModalSaveButton(),
          ],
        ),
      ),
    );
  }
}
