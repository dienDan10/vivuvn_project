import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../model/restaurant.dart';
import 'btn_open_map.dart';
import 'restaurant_detail_modal.dart';

class RestaurantCarouselItem extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCarouselItem({super.key, required this.restaurant});

  void _showDetailsModel(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final context) => RestaurantDetailModal(restaurant: restaurant),
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
                // Restaurant Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/image-placeholder.jpeg',
                    image: restaurant.photos.isNotEmpty
                        ? restaurant.photos[0]
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

                // Restaurant Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
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
                            '${restaurant.rating}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          // Rating count
                          const SizedBox(width: 4),
                          Text('(${restaurant.userRatingCount})'),

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
                              'assets/icons/restaurant.svg',
                              width: 16,
                              height: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              restaurant.address,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 3,
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
                  ButtonOpenMap(mapUrl: restaurant.googleMapsUri ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
