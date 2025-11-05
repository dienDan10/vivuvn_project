import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/routes.dart';
import '../../models/itinerary.dart';
import 'delete_confirm_dialog.dart';

class EditItineraryModal extends ConsumerStatefulWidget {
  final Itinerary itinerary;
  const EditItineraryModal({super.key, required this.itinerary});

  @override
  ConsumerState<EditItineraryModal> createState() => _EditItineraryModalState();
}

class _EditItineraryModalState extends ConsumerState<EditItineraryModal> {
  void _showDeleteConfirmationDialog() {
    context.pop();
    showDialog(
      context: context,
      builder: (final BuildContext ctx) {
        return DeleteConfirmDialog(itineraryId: widget.itinerary.id);
      },
    );
  }

  void _editItinerary() {
    context.pop();
    context.push(createItineraryDetailRoute(widget.itinerary.id));
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit, size: 20.0),
            title: const Text(
              'Sửa chuyến đi',
              style: TextStyle(fontSize: 14.0),
            ),
            onTap: _editItinerary,
          ),
          ListTile(
            leading: const Icon(Icons.public, size: 20.0),
            title: const Text(
              'Đặt là công khai',
              style: TextStyle(fontSize: 14.0),
            ),
            onTap: () {
              Navigator.of(context).pop();
              // Handle set as public action
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, size: 20.0),
            title: const Text(
              'Xóa chuyến đi',
              style: TextStyle(fontSize: 14.0),
            ),
            onTap: _showDeleteConfirmationDialog,
          ),
        ],
      ),
    );
  }
}
