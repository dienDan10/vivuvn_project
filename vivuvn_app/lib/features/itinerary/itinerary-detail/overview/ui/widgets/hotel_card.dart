import 'package:flutter/material.dart';

import '../../data/dto/hotel_item_response.dart';
import 'hotel_card_expanded.dart';
import 'hotel_card_header.dart';

class HotelCard extends StatefulWidget {
  const HotelCard({required this.hotel, this.index, super.key});

  final HotelItemResponse hotel;
  final int? index;

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;

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
            onTap: _toggle,
          ),
          if (_expanded)
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
