import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/routes.dart';
import '../../models/itinerary.dart';
import 'current_itinerary_provider.dart';
import 'itinerary_image.dart';
import 'itinerary_main_info.dart';
import 'itinerary_more_button.dart';
import 'itinerary_owner_badge.dart';

class ItineraryListItem extends StatelessWidget {
  final Itinerary itinerary;

  const ItineraryListItem({super.key, required this.itinerary});

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(createItineraryDetailRoute(itinerary.id)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ProviderScope(
          overrides: [currentItineraryProvider.overrideWithValue(itinerary)],
          child: const Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ItineraryImage(),

                  SizedBox(width: 12),
                  // Thông tin hành trình
                  Expanded(
                    child: SizedBox(
                      height: 110,
                      child: Stack(
                        children: [
                          ItineraryMainInfo(),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: ItineraryOwnerBadge(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ItineraryMoreButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
