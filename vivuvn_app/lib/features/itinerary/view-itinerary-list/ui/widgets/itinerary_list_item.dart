import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/itinerary.dart';
import 'edit_itinerary_modal.dart';

class ItineraryListItem extends StatelessWidget {
  final Itinerary itinerary;

  const ItineraryListItem({super.key, required this.itinerary});

  void _showBottomSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (final BuildContext ctx) {
        return const EditItineraryModal();
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Itinerary Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/image-placeholder.jpeg',
              image: itinerary.imageUrl,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              imageErrorBuilder:
                  (final context, final error, final stackTrace) {
                    return Image.asset(
                      'assets/images/image-placeholder.jpeg',
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    );
                  },
            ),
          ),

          // Itinerary Details
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  itinerary.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${DateFormat.MMMd('vi').format(itinerary.startDate)} - ${DateFormat.yMMMd('vi').format(itinerary.endDate)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Itinerary Actions
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: InkWell(
              child: const Icon(Icons.more_vert_outlined, size: 32.0),
              onTap: () => _showBottomSheet(context),
            ),
          ),
        ],
      ),
    );
  }
}
