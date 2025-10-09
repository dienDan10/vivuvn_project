import 'package:flutter/material.dart';

class CreateItineraryForm extends StatefulWidget {
  final ScrollController scrollController;
  const CreateItineraryForm({super.key, required this.scrollController});

  @override
  State<CreateItineraryForm> createState() => _CreateItineraryFormState();
}

class _CreateItineraryFormState extends State<CreateItineraryForm> {
  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Itinerary Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Destination',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle create itinerary logic here
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ],
    );
  }
}
