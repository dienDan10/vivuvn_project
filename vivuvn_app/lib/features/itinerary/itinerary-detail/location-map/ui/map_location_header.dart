import 'package:flutter/material.dart';

import '../../detail/ui/btn_back.dart';
import 'day_list.dart';

class MapLocationHeader extends StatelessWidget {
  const MapLocationHeader({super.key});

  @override
  Widget build(final BuildContext context) {
    return const Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Row(
        children: [
          // Back Button
          ButtonBack(),
          SizedBox(width: 8),

          // list of days for selection
          DayList(),
        ],
      ),
    );
  }
}
