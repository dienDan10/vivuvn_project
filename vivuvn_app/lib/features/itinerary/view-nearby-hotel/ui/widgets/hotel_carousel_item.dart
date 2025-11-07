import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../view-nearby-restaurant/ui/widgets/btn_open_map.dart';
import '../../data/model/hotel.dart';
import 'btn_add_to_itinerary.dart';
import 'hotel_detail_modal.dart';

class HotelCarouselItem extends StatelessWidget {
  final Hotel hotel;
  const HotelCarouselItem({super.key, required this.hotel});

  void _showDetailsModel(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final context) => HotelDetailModal(hotel: hotel),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsModel(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Main info row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/image-placeholder.jpeg',
                    image: hotel.photos.isNotEmpty
                        ? hotel.photos[0]
                        : 'assets/images/image-placeholder.jpeg',
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
                const SizedBox(width: 12),

                // Hotel Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotel.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Rating row
                      Row(
                        children: [
                          // Star Icon
                          const Icon(
                            Icons.star,
                            color: Colors.orangeAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          // Rating Text
                          Text(
                            '${hotel.rating}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          // Rating count
                          const SizedBox(width: 4),
                          Text('(${hotel.userRatingCount})'),

                          // google image
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            'assets/images/google.svg',
                            width: 16,
                            height: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Address row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: SvgPicture.asset(
                              'assets/icons/hotel.svg',
                              width: 16,
                              height: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              hotel.address,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Buttons Groups
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Map Button
                  ButtonOpenMap(mapUrl: hotel.googleMapsUri ?? ''),

                  const SizedBox(width: 12),

                  // Add to Itinerary Button
                  ButtonAddToItinerary(hotel: hotel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
