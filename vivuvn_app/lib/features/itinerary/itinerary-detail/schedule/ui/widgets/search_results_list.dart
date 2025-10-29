import 'package:flutter/material.dart';

import '../../../overview/controller/favourite_places_controller.dart';
import '../../../overview/modal/location.dart';

class SearchResultsList extends StatelessWidget {
  final List<Location> results;
  final List<FavouritePlace> favPlaces;
  final ValueChanged<Location>? onSelected;

  const SearchResultsList({
    super.key,
    required this.results,
    required this.favPlaces,
    this.onSelected,
  });

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (final context, final index) {
        final location = results[index];
        final isFavorite = favPlaces.any(
          (final f) => f.locationId == location.id,
        );

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isFavorite ? Colors.green : Colors.grey.shade300,
              width: 1,
            ),
          ),
          elevation: isFavorite ? 4 : 1,
          shadowColor: isFavorite ? Colors.greenAccent : Colors.black12,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(
              location.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(location.address),
            onTap: () => onSelected?.call(location),
          ),
        );
      },
    );
  }
}
