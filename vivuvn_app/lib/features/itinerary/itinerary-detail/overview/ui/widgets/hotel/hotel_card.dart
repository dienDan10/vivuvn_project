import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/hotel_card_expand_controller.dart';
import '../../../data/dto/hotel_item_response.dart';
import 'hotel_card_expanded.dart';
import 'hotel_card_header.dart';

class HotelCard extends ConsumerWidget {
  const HotelCard({required this.hotel, this.index, super.key});

  final HotelItemResponse hotel;
  final int? index;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final expandState = ref.watch(hotelCardExpandControllerProvider);
    final isExpanded = expandState.isExpanded(hotel.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HotelCardHeader(
            hotelId: hotel.id,
            name: hotel.name,
            address: hotel.address,
            checkInDate: hotel.checkInDate,
            checkOutDate: hotel.checkOutDate,
            imageUrl: hotel.imageUrl,
            onTap: () {
              ref
                  .read(hotelCardExpandControllerProvider.notifier)
                  .toggle(hotel.id);
            },
          ),
          if (isExpanded)
            HotelCardExpanded(
              hotelId: hotel.id,
              hotelName: hotel.name,
              checkInDate: hotel.checkInDate,
              checkOutDate: hotel.checkOutDate,
              cost: hotel.cost,
              note: hotel.note,
            ),
        ],
      ),
    );
  }
}
