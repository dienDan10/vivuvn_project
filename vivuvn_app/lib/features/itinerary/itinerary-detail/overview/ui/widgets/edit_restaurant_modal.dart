import 'package:flutter/material.dart';

import '../../data/dto/restaurant_item_response.dart';
import 'add_restaurant_modal.dart';

Future<void> showEditRestaurantModal(
  final BuildContext context, {
  required final RestaurantItemResponse restaurantToEdit,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (final context) =>
        AddRestaurantModal(restaurantToEdit: restaurantToEdit),
  );
}
