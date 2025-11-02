import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/restaurants_controller.dart';
import 'restaurant_date_picker.dart';
import 'restaurant_save_button.dart';
import 'restaurant_search_field.dart';
import 'restaurant_search_modal.dart';
import 'restaurant_time_picker_row.dart';

class AddRestaurantModal extends ConsumerStatefulWidget {
  const AddRestaurantModal({super.key});

  @override
  ConsumerState<AddRestaurantModal> createState() => _AddRestaurantModalState();
}

class _AddRestaurantModalState extends ConsumerState<AddRestaurantModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(restaurantsControllerProvider.notifier).initializeForm();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final formState = ref.watch(restaurantsControllerProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
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
                    'Thêm nhà hàng',
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

            // Search field (read-only, opens modal on tap)
            RestaurantSearchField(
              selectedLocation: formState.formSelectedLocation,
              onTap: () => _openSearchModal(context),
            ),
            const SizedBox(height: 16),

            // Date picker
            RestaurantDatePicker(
              label: 'Ngày ăn',
              date: formState.formMealDate,
              onTap: () => _selectMealDate(context),
            ),
            const SizedBox(height: 16),
            // Time picker
            RestaurantTimePickerRow(
              label: 'Giờ ăn',
              timeText: formState.formMealTime,
              onTap: () => _selectMealTime(context),
            ),
            const SizedBox(height: 24),

            // Save button
            RestaurantSaveButton(
              enabled: formState.formIsValid,
              onPressed: () => _handleSave(context),
              isEditMode: false,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSearchModal(final BuildContext context) async {
    final result = await showRestaurantSearchModal(context);
    if (result != null) {
      ref.read(restaurantsControllerProvider.notifier).setFormLocation(result);
    }
  }

  // Đã tách thành RestaurantDatePicker

  Future<void> _selectMealDate(final BuildContext context) async {
    final current = ref.read(restaurantsControllerProvider).formMealDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      ref.read(restaurantsControllerProvider.notifier).setFormMealDate(picked);
    }
  }

  Future<void> _selectMealTime(final BuildContext context) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (picked != null) {
      final timeStr = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
      ref.read(restaurantsControllerProvider.notifier).setFormMealTime(timeStr);
    }
  }

  Future<void> _handleSave(final BuildContext context) async {
    final success = await ref
        .read(restaurantsControllerProvider.notifier)
        .saveForm();

    if (success && context.mounted) Navigator.pop(context);
  }
}
