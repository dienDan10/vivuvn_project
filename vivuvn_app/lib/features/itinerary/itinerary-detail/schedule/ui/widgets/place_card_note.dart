import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';
import '../../model/location.dart';

class PlaceCardNote extends ConsumerStatefulWidget {
  const PlaceCardNote({super.key, required this.location});

  final Location location;

  @override
  ConsumerState<PlaceCardNote> createState() => _PlaceCardNoteState();
}

class _PlaceCardNoteState extends ConsumerState<PlaceCardNote> {
  String? note;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(itineraryScheduleControllerProvider);
      final currentDay = state.days.firstWhereOrNull(
        (final d) => d.id == state.selectedDayId,
      );
      final currentItem = currentDay?.items.firstWhereOrNull(
        (final i) => i.location.id == widget.location.id,
      );
      if (mounted) setState(() => note = currentItem?.note);
    });
  }

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
      final currentDay = ref
          .read(itineraryScheduleControllerProvider)
          .days
          .firstWhereOrNull(
            (final d) =>
                d.id ==
                ref.read(itineraryScheduleControllerProvider).selectedDayId,
          );

      final currentItem = currentDay?.items.firstWhereOrNull(
        (final i) => i.location.id == widget.location.id,
      );

      if (currentItem == null || currentDay == null) return;

      await ref
          .read(itineraryScheduleControllerProvider.notifier)
          .updateItem(
            dayId: currentDay.id,
            itemId: currentItem.itineraryItemId,
            note: newNote,
          );

      if (mounted) {
        setState(() => note = newNote.isEmpty ? null : newNote);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã lưu ghi chú thành công!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return note == null
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
                  Icon(Icons.note_alt_outlined, size: 18, color: Colors.grey),
                  SizedBox(width: 6),
                  Text(
                    'Ghi chú:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                  child: Text(note!, style: const TextStyle(fontSize: 14)),
                ),
              ),
            ],
          );
  }
}
