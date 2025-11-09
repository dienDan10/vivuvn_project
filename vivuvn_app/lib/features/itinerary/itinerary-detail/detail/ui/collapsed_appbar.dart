import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/itinerary_detail_controller.dart';
import 'btn_back.dart';
import 'btn_settings.dart';

class CollapsedAppbar extends ConsumerWidget {
  const CollapsedAppbar({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final itinerary = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary!,
      ),
    );

    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
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
