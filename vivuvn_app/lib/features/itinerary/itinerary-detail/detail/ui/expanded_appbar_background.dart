import 'package:flutter/material.dart';

import '../../../../../common/helper/app_constants.dart';
import 'widgets/itinerary_appbar_buttons.dart';
import 'widgets/itinerary_background_image.dart';
import 'widgets/itinerary_date_range.dart';
import 'widgets/itinerary_name_editor.dart';
import 'widgets/itinerary_provinces.dart';

class ExpandedAppbarBackground extends StatelessWidget {
  const ExpandedAppbarBackground({super.key});

  @override
  Widget build(final BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        ItineraryBackgroundImage(),
        ItineraryAppbarButtons(),
        Positioned(
          top: appbarExpandedHeight * 0.4,
          left: 20,
          right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItineraryNameEditor(),
                SizedBox(height: 8),
                ItineraryDateRange(),
                ItineraryProvinces(),
              ],
            ),
        ),
      ],
    );
  }
}
