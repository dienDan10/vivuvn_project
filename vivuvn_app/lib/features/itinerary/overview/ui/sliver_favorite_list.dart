import 'package:flutter/material.dart';

import '../models/dummy_favorite_places.dart';
import 'favorite_item_card.dart';

class SliverFavoriteList extends StatelessWidget {
  const SliverFavoriteList({super.key});

  @override
  Widget build(final BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((final context, final index) {
        if (index == dummyFavoritePlaces.length) {
          return _buildAddButton();
        }
        final place = dummyFavoritePlaces[index];
        return FavoriteItemCard(place: place);
      }, childCount: dummyFavoritePlaces.length + 1),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Thêm địa điểm yêu thích'),
      ),
    );
  }
}
