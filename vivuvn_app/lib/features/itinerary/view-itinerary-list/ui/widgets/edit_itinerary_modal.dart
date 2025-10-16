import 'package:flutter/material.dart';

class EditItineraryModal extends StatelessWidget {
  const EditItineraryModal({super.key});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Itinerary'),
            onTap: () {
              Navigator.of(context).pop();
              // Handle edit action
            },
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Set as public'),
            onTap: () {
              Navigator.of(context).pop();
              // Handle set as public action
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Itinerary'),
            onTap: () {
              Navigator.of(context).pop();
              // Handle delete action
            },
          ),
        ],
      ),
    );
  }
}
