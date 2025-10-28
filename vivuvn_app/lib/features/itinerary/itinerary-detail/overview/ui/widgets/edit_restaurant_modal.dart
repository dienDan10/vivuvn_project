import 'package:flutter/material.dart';

import '../../controller/hotels_restaurants_controller.dart';
import 'add_restaurant_modal.dart';

Future<void> showEditRestaurantModal(
  final BuildContext context, {
  required final RestaurantItem restaurantToEdit,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (final context) =>
        AddRestaurantModal(restaurantToEdit: restaurantToEdit),
  );
}
