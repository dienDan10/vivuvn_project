import 'package:flutter/material.dart';

import '../../data/dto/hotel_item_response.dart';
import 'add_hotel_modal.dart';

Future<void> showEditHotelModal(
  final BuildContext context, {
  required final HotelItemResponse hotelToEdit,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (final context) => AddHotelModal(hotelToEdit: hotelToEdit),
  );
}
