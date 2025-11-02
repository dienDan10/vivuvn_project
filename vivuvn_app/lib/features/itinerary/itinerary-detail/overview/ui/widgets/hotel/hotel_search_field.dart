import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/hotels_controller.dart';
import 'hotel_search_modal.dart';

class HotelSearchField extends ConsumerWidget {
  const HotelSearchField({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final hotelsState = ref.watch(hotelsControllerProvider);
    final controller = ref.read(hotelsControllerProvider.notifier);

    return InkWell(
      onTap: () async {
        final result = await showHotelSearchModal(context);
        if (result != null) {
          controller.setFormLocation(result);
        }
      },
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
                hotelsState.formDisplayName.isEmpty
                    ? 'Tìm tên hoặc địa chỉ khách sạn'
                    : hotelsState.formDisplayName,
                style: TextStyle(
                  fontSize: 16,
                  color: hotelsState.formDisplayName.isNotEmpty
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
