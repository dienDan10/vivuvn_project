import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../controller/restaurants_controller.dart';
import '../../data/dto/restaurant_item_response.dart';
import '../../modal/location.dart';
import 'restaurant_date_picker.dart';
import 'restaurant_save_button.dart';
import 'restaurant_search_field.dart';
import 'restaurant_search_modal.dart';

class AddRestaurantModal extends ConsumerStatefulWidget {
  final RestaurantItemResponse? restaurantToEdit;

  const AddRestaurantModal({super.key, this.restaurantToEdit});

  @override
  ConsumerState<AddRestaurantModal> createState() => _AddRestaurantModalState();
}

class _AddRestaurantModalState extends ConsumerState<AddRestaurantModal> {
  Location? _selectedLocation;
  DateTime? _mealDate;

  @override
  void initState() {
    super.initState();
    if (widget.restaurantToEdit != null) {
      _mealDate = widget.restaurantToEdit!.mealDate;
    } else {
      _mealDate = DateTime.now();
    }
  }

  @override
  Widget build(final BuildContext context) {
    final isEditMode = widget.restaurantToEdit != null;

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
                Expanded(
                  child: Text(
                    isEditMode ? 'Sửa nhà hàng' : 'Thêm nhà hàng',
                    style: const TextStyle(
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
              selectedLocation: _selectedLocation,
              onTap: () => _openSearchModal(context),
            ),
            const SizedBox(height: 16),

            // Date picker
            RestaurantDatePicker(
              label: 'Ngày ăn',
              date: _mealDate,
              onTap: () => _selectMealDate(context),
            ),
            const SizedBox(height: 24),

            // Save button
            RestaurantSaveButton(
              enabled: (_selectedLocation != null || isEditMode),
              onPressed: () => _handleSave(context),
              isEditMode: isEditMode,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSearchModal(final BuildContext context) async {
    final result = await showRestaurantSearchModal(context);
    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }

  // Đã tách thành RestaurantDatePicker

  Future<void> _selectMealDate(final BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _mealDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _mealDate = picked;
      });
    }
  }

  Future<void> _handleSave(final BuildContext context) async {
    final name = _selectedLocation?.name ?? widget.restaurantToEdit?.name ?? '';

    if (name.isEmpty) return;

    if (widget.restaurantToEdit != null) {
      // Update existing restaurant: only update date/time via per-field endpoints
      if (_mealDate != null) {
        final time = DateFormat('HH:mm:ss').format(_mealDate!);
        await ref
            .read(restaurantsControllerProvider.notifier)
            .updateRestaurantDate(
              id: widget.restaurantToEdit!.id,
              date: _mealDate!,
            );
        await ref
            .read(restaurantsControllerProvider.notifier)
            .updateRestaurantTime(id: widget.restaurantToEdit!.id, time: time);
      }
      // Note: name/address editing is not supported by per-field APIs currently.
      Navigator.pop(context);
      return;
    }

    // Add new restaurant
    final googlePlaceId = _selectedLocation?.googlePlaceId;
    if (googlePlaceId == null) return; // cannot add without googlePlaceId
    final success = await ref
        .read(restaurantsControllerProvider.notifier)
        .addRestaurant(
          googlePlaceId: googlePlaceId,
          mealDate: _mealDate ?? DateTime.now(),
        );

    if (success) Navigator.pop(context);
  }
}
