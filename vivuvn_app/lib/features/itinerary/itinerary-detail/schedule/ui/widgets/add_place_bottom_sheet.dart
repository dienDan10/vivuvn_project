import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';
import 'search_location_field.dart';

class AddPlaceBottomSheet extends ConsumerWidget {
  final String type;

  const AddPlaceBottomSheet({super.key, this.type = 'place'});

  String _getHintText() {
    switch (type) {
      case 'hotel':
        return 'Tìm khách sạn hoặc nhà nghỉ...';
      case 'restaurant':
        return 'Tìm nhà hàng hoặc quán ăn...';
      default:
        return 'Tìm kiếm địa điểm...';
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SearchLocationField(
                hintText: _getHintText(),
                onSelected: (final location) async {
                  final messenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);

                  final dayId = ref.read(
                    itineraryScheduleControllerProvider.select(
                      (final s) => s.selectedDayId,
                    ),
                  );

                  if (dayId == null) {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Chưa chọn ngày nào')),
                    );
                    return;
                  }

                  await ref
                      .read(itineraryScheduleControllerProvider.notifier)
                      .addItemToDay(dayId, location.id);

                  if (!context.mounted) return;
                  messenger.showSnackBar(
                    SnackBar(content: Text('Đã thêm: ${location.name}')),
                  );
                  navigator.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
