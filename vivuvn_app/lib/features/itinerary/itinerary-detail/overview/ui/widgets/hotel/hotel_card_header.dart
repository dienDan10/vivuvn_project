import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../favourite_place/place_card_image.dart';

class HotelCardHeader extends StatelessWidget {
  const HotelCardHeader({
    required this.hotelId,
    required this.name,
    required this.address,
    required this.checkInDate,
    required this.checkOutDate,
    required this.imageUrl,
    required this.onTap,
    super.key,
  });

  final String hotelId;
  final String name;
  final String address;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Nhận phòng: ${checkInDate != null ? dateFormatter.format(checkInDate!) : '--/--'} - Trả phòng: ${checkOutDate != null ? dateFormatter.format(checkOutDate!) : '--/--'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            PlaceCardImage(
              imageUrl: imageUrl,
              size: 80,
            ),
          ],
        ),
      ),
    );
  }
}
