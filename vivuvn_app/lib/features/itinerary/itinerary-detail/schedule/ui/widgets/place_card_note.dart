import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';
import '../../model/location.dart';

class PlaceCardNote extends ConsumerStatefulWidget {
  const PlaceCardNote({
    super.key,
    required this.dayId,
    required this.itemId,
    required this.location,
  });

  final int dayId;
  final int itemId;
  final Location location;

  @override
  ConsumerState<PlaceCardNote> createState() => _PlaceCardNoteState();
}

class _PlaceCardNoteState extends ConsumerState<PlaceCardNote> {
  String? note;

  @override
  void initState() {
    super.initState();
    final state = ref.read(itineraryScheduleControllerProvider);
    final currentDay = state.days.firstWhereOrNull(
      (final d) => d.id == widget.dayId,
    );
    final currentItem = currentDay?.items.firstWhereOrNull(
      (final i) => i.itineraryItemId == widget.itemId,
    );
    note = currentItem?.note;
  }

  Future<void> _editNote() async {
    final controllerText = TextEditingController(text: note ?? '');
    final newNote = await showDialog<String>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Ghi chú'),
        content: TextField(
          controller: controllerText,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Nhập ghi chú...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controllerText.text.trim()),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (newNote != null) {
      await ref
          .read(itineraryScheduleControllerProvider.notifier)
          .updateItem(
            dayId: widget.dayId,
            itemId: widget.itemId,
            note: newNote,
          );
      setState(() => note = newNote);
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
        : GestureDetector(
            onTap: _editNote,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(note!),
            ),
          );
  }
}
