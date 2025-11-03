import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../../../../../screens/create_itinerary_screen.dart';
import '../../../join-itinerary/ui/join_itinerary_modal.dart';

class ButtonAddItinerary extends StatefulWidget {
  const ButtonAddItinerary({super.key});

  @override
  State<ButtonAddItinerary> createState() => _ButtonAddItineraryState();
}

class _ButtonAddItineraryState extends State<ButtonAddItinerary> {
  final _key = GlobalKey<ExpandableFabState>();
  void _showCreateItineraryBottomSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: false,
      builder: (final context) => const CreateItineraryScreen(),
    );
  }

  void _joinItineraryBottomSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (final context) => const JoinItineraryModal(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return HeroMode(
      enabled: false,
      child: ExpandableFab(
      key: _key,
      overlayStyle: ExpandableFabOverlayStyle(
        color: Colors.black.withValues(alpha: 0.7),
      ),
      distance: 70,
      childrenAnimation: ExpandableFabAnimation.none,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add, size: 26),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.close, size: 26),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
      ),
      children: [
        Row(
          children: [
            Text(
              'Tạo chuyến đi mới',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: 'list_fab_create',
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              onPressed: () {
                // Close the expandable FAB
                final state = _key.currentState;
                state?.toggle();
                // Show the bottom sheet
                _showCreateItineraryBottomSheet(context);
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Tham gia chuyến đi',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: 'list_fab_join',
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              onPressed: () {
                // Close the expandable FAB
                final state = _key.currentState;
                state?.toggle();
                // Show the bottom sheet
                _joinItineraryBottomSheet(context);
              },
              child: const Icon(Icons.group_add),
            ),
          ],
        ),
      ],
      ),
    );
  }
}
