import 'package:flutter/material.dart';

import '../schedule_data.dart';
import 'add_place_bottom_sheet.dart';

class SuggestedPlacesTile extends StatelessWidget {
  const SuggestedPlacesTile({super.key});

  @override
  Widget build(final BuildContext context) {
    return ExpansionTile(
      title: const Text('Địa điểm gợi ý'),
      children: [
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: samplePlaces.length,
            itemBuilder: (final context, final index) {
              final place = samplePlaces[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (final context) => const FractionallySizedBox(
                        heightFactor: 0.8,
                        child: AddPlaceBottomSheet(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.blue[200],
                        child: const Icon(Icons.place),
                      ),
                      Text(place.title, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
