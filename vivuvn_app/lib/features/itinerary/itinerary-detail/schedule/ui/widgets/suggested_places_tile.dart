import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../schedule_data.dart';
import 'add_place_bottom_sheet.dart';
import 'suggested_place_item.dart';

class SuggestedPlacesTile extends ConsumerWidget {
  const SuggestedPlacesTile({super.key});

  void _openAddPlaceSheet(final BuildContext context, final WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.8,
        child: AddPlaceBottomSheet(type: 'place'),
      ),
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return ExpansionTile(
      title: const Text('Địa điểm gợi ý'),
      children: [
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: samplePlaces.length,
            separatorBuilder: (_, final __) => const SizedBox(width: 12),
            itemBuilder: (final context, final index) {
              final place = samplePlaces[index];
              return SuggestedPlaceItem(
                title: place.title,
                onTap: () => _openAddPlaceSheet(context, ref),
              );
            },
          ),
        ),
      ],
    );
  }
}
