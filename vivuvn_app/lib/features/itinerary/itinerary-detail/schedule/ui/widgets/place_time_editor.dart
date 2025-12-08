import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../detail/controller/itinerary_detail_controller.dart';
import '../../controller/itinerary_schedule_controller.dart';
import '../../model/itinerary_item.dart';

class PlaceTimeEditor extends ConsumerWidget {
  const PlaceTimeEditor({super.key, required this.item});

  final ItineraryItem item;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isOwner = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary?.isOwner ?? false,
      ),
    );

    return InkWell(
      onTap: !isOwner
          ? null
          : () async {
              TimeOfDay start =
                  item.startTime ?? const TimeOfDay(hour: 8, minute: 0);
              TimeOfDay end =
                  item.endTime ?? const TimeOfDay(hour: 9, minute: 0);
              final format = NumberFormat('00');

              await showDialog(
                context: context,
                builder: (final context) {
                  return StatefulBuilder(
                    builder: (final context, final setState) => AlertDialog(
                      title: const Text('Chọn thời gian tham quan'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTimePickerColumn(
                                'Bắt đầu',
                                start,
                                (final picked) =>
                                    setState(() => start = picked),
                                format,
                                context,
                              ),
                              _buildTimePickerColumn(
                                'Kết thúc',
                                end,
                                (final picked) => setState(() => end = picked),
                                format,
                                context,
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (end.hour < start.hour ||
                                (end.hour == start.hour &&
                                    end.minute <= start.minute)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Giờ kết thúc phải sau giờ bắt đầu!',
                                  ),
                                ),
                              );
                              return;
                            }

                            await ref
                                .read(
                                  itineraryScheduleControllerProvider.notifier,
                                )
                                .updateItem(
                                  itemId: item.itineraryItemId,
                                  startTime: start,
                                  endTime: end,
                                );

                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Cập nhật thời gian thành công!',
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Lưu'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.mode_edit_outline_rounded,
          size: 16,
          color: Colors.blue,
        ),
      ),
    );
  }

  Column _buildTimePickerColumn(
    final String label,
    final TimeOfDay time,
    final void Function(TimeOfDay) onPicked,
    final NumberFormat format,
    final BuildContext context,
  ) {
    return Column(
      children: [
        Text(label),
        TextButton.icon(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time,
              initialEntryMode: TimePickerEntryMode.input,
            );
            if (picked != null) onPicked(picked);
          },
          icon: const Icon(Icons.access_time),
          label: Text(
            '${format.format(time.hour)}:${format.format(time.minute)}',
          ),
        ),
      ],
    );
  }
}
