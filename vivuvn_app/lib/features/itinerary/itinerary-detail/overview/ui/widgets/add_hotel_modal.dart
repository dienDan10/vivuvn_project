import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../controller/hotels_controller.dart';
import '../../data/dto/hotel_item_response.dart';
import '../../modal/location.dart';
import 'hotel_search_modal.dart';

class AddHotelModal extends ConsumerStatefulWidget {
  final HotelItemResponse? hotelToEdit;

  const AddHotelModal({super.key, this.hotelToEdit});

  @override
  ConsumerState<AddHotelModal> createState() => _AddHotelModalState();
}

class _AddHotelModalState extends ConsumerState<AddHotelModal> {
  Location? _selectedLocation;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  @override
  void initState() {
    super.initState();
    if (widget.hotelToEdit != null) {
      _checkInDate = widget.hotelToEdit!.checkInDate;
      _checkOutDate = widget.hotelToEdit!.checkOutDate;
    } else {
      _checkInDate = DateTime.now();
      _checkOutDate = DateTime.now();
    }
  }

  @override
  Widget build(final BuildContext context) {
    final isEditMode = widget.hotelToEdit != null;

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
                Expanded(
                  child: Text(
                    isEditMode ? 'Sửa khách sạn' : 'Thêm khách sạn',
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
                            widget.hotelToEdit?.name ??
                            'Tìm tên hoặc địa chỉ khách sạn',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              _selectedLocation != null ||
                                  widget.hotelToEdit != null
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

            // Date pickers
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    context: context,
                    label: 'Check-in',
                    date: _checkInDate,
                    onTap: () => _selectCheckInDate(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDatePicker(
                    context: context,
                    label: 'Check-out',
                    date: _checkOutDate,
                    onTap: () => _selectCheckOutDate(context),
                  ),
                ),
              ],
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
    final result = await showHotelSearchModal(context);
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
    );
  }

  Future<void> _selectCheckInDate(final BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        // Auto adjust check-out if it's before check-in
        if (_checkOutDate != null && _checkOutDate!.isBefore(picked)) {
          _checkOutDate = picked.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectCheckOutDate(final BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _checkOutDate ??
          (_checkInDate?.add(const Duration(days: 1)) ?? DateTime.now()),
      firstDate: _checkInDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  Future<void> _handleSave(final BuildContext context) async {
    final name = _selectedLocation?.name ?? widget.hotelToEdit?.name ?? '';

    if (name.isEmpty) return;

    if (widget.hotelToEdit != null) {
      // Update only the dates for existing hotel (API exposes per-field updates)
      final checkIn =
          _checkInDate ?? widget.hotelToEdit!.checkInDate ?? DateTime.now();
      final checkOut =
          _checkOutDate ??
          widget.hotelToEdit!.checkOutDate ??
          checkIn.add(const Duration(days: 1));
      final success = await ref
          .read(hotelsControllerProvider.notifier)
          .updateHotelDate(
            id: widget.hotelToEdit!.id,
            checkInDate: checkIn,
            checkOutDate: checkOut,
          );
      if (success) Navigator.pop(context);
      return;
    }

    // Add new hotel — requires googlePlaceId and date values
    final googlePlaceId = _selectedLocation?.googlePlaceId;
    if (googlePlaceId == null) return; // can't add without googlePlaceId

    final success = await ref
        .read(hotelsControllerProvider.notifier)
        .addHotel(
          googlePlaceId: googlePlaceId,
          checkInDate: _checkInDate ?? DateTime.now(),
          checkOutDate: _checkOutDate ?? _checkInDate ?? DateTime.now(),
        );

    if (success) Navigator.pop(context);
  }
}
