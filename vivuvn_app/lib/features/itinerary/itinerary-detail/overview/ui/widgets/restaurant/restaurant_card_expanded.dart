import 'package:flutter/material.dart';

import 'restaurant_cost_field.dart';
import 'restaurant_date_time_picker.dart';
import 'restaurant_delete_button.dart';
import 'restaurant_note_field.dart';

class RestaurantCardExpanded extends StatelessWidget {
  const RestaurantCardExpanded({
    required this.restaurantId,
    required this.restaurantName,
    required this.mealDate,
    required this.cost,
    required this.note,
    super.key,
  });

  final String restaurantId;
  final String restaurantName;
  final DateTime? mealDate;
  final double? cost;
  final String? note;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RestaurantDateTimePicker(
              restaurantId: restaurantId,
              mealDate: mealDate,
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            RestaurantCostField(restaurantId: restaurantId, initialCost: cost),
            const SizedBox(height: 12),
            RestaurantNoteField(restaurantId: restaurantId, initialNote: note),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RestaurantDeleteButton(
                  restaurantId: restaurantId,
                  restaurantName: restaurantName,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
