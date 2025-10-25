import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../controller/hotels_restaurants_controller.dart';
import '../../modal/location.dart';
import 'restaurant_search_modal.dart';

class AddRestaurantModal extends ConsumerStatefulWidget {
  final RestaurantItem? restaurantToEdit;

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
            InkWell(
              onTap: () => _openSearchModal(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedLocation?.name ??
                            widget.restaurantToEdit?.name ??
                            'Tìm tên hoặc địa chỉ nhà hàng',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              _selectedLocation != null ||
                                  widget.restaurantToEdit != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date picker
            _buildDatePicker(
              context: context,
              label: 'Ngày ăn',
              date: _mealDate,
              onTap: () => _selectMealDate(context),
            ),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_selectedLocation != null || isEditMode)
                    ? () => _handleSave(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isEditMode ? 'Cập nhật' : 'Thêm'),
              ),
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

  Widget _buildDatePicker({
    required final BuildContext context,
    required final String label,
    required final DateTime? date,
    required final VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date != null
                        ? DateFormat('dd/MM/yyyy').format(date)
                        : 'Chọn ngày',
                    style: TextStyle(
                      fontSize: 14,
                      color: date != null ? Colors.black : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.calendar_today, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

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

  void _handleSave(final BuildContext context) {
    final name = _selectedLocation?.name ?? widget.restaurantToEdit?.name ?? '';
    final address =
        _selectedLocation?.address ?? widget.restaurantToEdit?.address ?? '';

    if (name.isEmpty) return;

    if (widget.restaurantToEdit != null) {
      // Update existing restaurant
      ref
          .read(hotelsRestaurantsControllerProvider.notifier)
          .updateRestaurant(
            widget.restaurantToEdit!.id,
            name,
            address,
            _mealDate,
          );
    } else {
      // Add new restaurant
      ref
          .read(hotelsRestaurantsControllerProvider.notifier)
          .addRestaurant(name, address, _mealDate);
    }

    Navigator.pop(context);
  }
}
