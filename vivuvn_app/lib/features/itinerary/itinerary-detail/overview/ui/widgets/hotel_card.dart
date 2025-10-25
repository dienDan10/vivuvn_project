import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controller/hotels_restaurants_controller.dart';
import 'place_card_image.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({required this.hotel, this.index, super.key});

  final HotelItem hotel;
  final int? index;

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hotel.address,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                if (hotel.checkInDate != null || hotel.checkOutDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _formatDateRange(hotel.checkInDate, hotel.checkOutDate),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          PlaceCardImage(imageUrl: hotel.imageUrl, size: 80),
        ],
      ),
    );
  }

  String _formatDateRange(final DateTime? checkIn, final DateTime? checkOut) {
    final formatter = DateFormat('dd/MM/yyyy');
    if (checkIn != null && checkOut != null) {
      return 'Check-in: ${formatter.format(checkIn)} - Check-out: ${formatter.format(checkOut)}';
    } else if (checkIn != null) {
      return 'Check-in: ${formatter.format(checkIn)}';
    } else if (checkOut != null) {
      return 'Check-out: ${formatter.format(checkOut)}';
    }
    return '';
  }
}
