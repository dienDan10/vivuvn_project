import 'package:flutter/material.dart';

import '../../view-itinerary-list/models/itinerary.dart';
import 'btn_back.dart';
import 'btn_settings.dart';

class CollapsedAppbar extends StatelessWidget {
  final Itinerary itinerary;
  const CollapsedAppbar({super.key, required this.itinerary});

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 12,
        right: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ButtonBack(onAppbar: true),
          Expanded(
            child: Text(
              itinerary.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const ButtonSettings(onAppbar: true),
        ],
      ),
    );
  }
}
