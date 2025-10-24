import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';
import '../../model/location.dart';
import 'place_action_button_direction.dart';
import 'place_action_button_info.dart';
import 'place_action_button_location.dart';
import 'place_action_button_website.dart';
import 'place_info_row.dart';
import 'place_photos_section.dart';

class PlaceCardDetails extends ConsumerStatefulWidget {
  const PlaceCardDetails({super.key, required this.location});

  final Location location;

  @override
  ConsumerState<PlaceCardDetails> createState() => _PlaceCardDetailsState();
}

class _PlaceCardDetailsState extends ConsumerState<PlaceCardDetails> {
  String? note;

  Future<void> _editNote() async {
    final controllerText = TextEditingController(text: note ?? '');
    final newNote = await showDialog<String>(
      context: context,
      builder: (final context) {
        return AlertDialog(
          title: const Text('Ghi chú'),
          content: TextField(
            controller: controllerText,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Nhập ghi chú cho địa điểm này...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context, controllerText.text.trim()),
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );

    if (newNote != null) {
      setState(() {
        note = newNote.isEmpty ? null : newNote;
      });

      // ==== CẬP NHẬT API QUA RIVERPOD ====
      final controller = ref.read(itineraryScheduleControllerProvider.notifier);
      final state = ref.read(itineraryScheduleControllerProvider);

      final dayId = state.selectedDayId;
      final item = state.selectedItem;
      if (dayId != null && item != null) {
        await controller.updateItem(
          dayId: dayId,
          itemId: item.itineraryItemId,
          note: note,
        );
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==== PHẦN GHI CHÚ ====
          note == null
              ? TextButton.icon(
                  onPressed: _editNote,
                  icon: const Icon(Icons.note_add_outlined, size: 20),
                  label: const Text('Thêm ghi chú'),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Ghi chú:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: _editNote,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          note!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),

          const SizedBox(height: 8),

          // ==== Thông tin địa điểm ====
          if (widget.location.address.isNotEmpty)
            PlaceInfoRow(
              icon: Icons.location_on_outlined,
              text: widget.location.address,
            ),
          if (widget.location.provinceName.isNotEmpty)
            PlaceInfoRow(
              icon: Icons.map_outlined,
              text: widget.location.provinceName,
            ),
          if (widget.location.rating > 0)
            PlaceInfoRow(
              icon: Icons.star_rate_rounded,
              text:
                  '${widget.location.rating} (${widget.location.ratingCount ?? 0} đánh giá)',
            ),

          const SizedBox(height: 12),

          if (widget.location.photos.length > 1)
            PlacePhotosSection(
              photos: widget.location.photos,
              locationId: widget.location.id,
            ),

          const SizedBox(height: 16),

          // ==== Các nút hành động ====
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                PlaceActionButtonInfo(location: widget.location),
                const SizedBox(width: 8),
                const PlaceActionButtonLocation(),
                const SizedBox(width: 8),
                const PlaceActionButtonDirection(),
                const SizedBox(width: 8),
                const PlaceActionButtonWebsite(),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
