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
                  final result = await ref
                      .read(itineraryScheduleControllerProvider.notifier)
                      .addLocationToSelectedDay(
                        locationId: location.id,
                        locationName: location.name,
                      );

                  if (!context.mounted) return;

                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    SnackBar(content: Text(result.message)),
                  );

                  if (result.isSuccess) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
