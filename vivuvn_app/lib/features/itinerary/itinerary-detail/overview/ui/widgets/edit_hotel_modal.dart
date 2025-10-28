import 'package:flutter/material.dart';

import '../../controller/hotels_restaurants_controller.dart';
import 'add_hotel_modal.dart';

Future<void> showEditHotelModal(
  final BuildContext context, {
  required final HotelItem hotelToEdit,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (final context) => AddHotelModal(hotelToEdit: hotelToEdit),
  );
}
