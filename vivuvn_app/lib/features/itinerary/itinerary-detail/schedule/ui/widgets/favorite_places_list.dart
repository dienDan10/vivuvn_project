import 'package:flutter/material.dart';

import '../../../overview/data/dto/favourite_places_response.dart';
import '../../../overview/models/location.dart';

class FavoritePlacesList extends StatelessWidget {
  final List<FavouritePlacesResponse> favPlaces;
  final ValueChanged<Location>? onSelected;

  const FavoritePlacesList({
    super.key,
    required this.favPlaces,
    this.onSelected,
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Địa điểm yêu thích',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: favPlaces.isEmpty
              ? const Center(child: Text('Chưa có địa điểm yêu thích nào.'))
              : ListView.builder(
                  itemCount: favPlaces.length,
                  itemBuilder: (final context, final index) {
                    final place = favPlaces[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      elevation: 1,
                      shadowColor: Colors.black12,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          place.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(place.provinceName),
                        onTap: () {
                          onSelected?.call(
                            Location(
                              id: place.locationId,
                              name: place.name,
                              address: place.provinceName,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
