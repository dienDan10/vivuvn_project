import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../schedule/ui/widgets/AI-generate/generate_ai_modal.dart';

class ButtonGenerateItinerary extends StatefulWidget {
  const ButtonGenerateItinerary({super.key});

  @override
  State<ButtonGenerateItinerary> createState() =>
      _ButtonGenerateItineraryState();
}

class _ButtonGenerateItineraryState extends State<ButtonGenerateItinerary> {
  final _fabKey = GlobalKey<ExpandableFabState>();
  void _showCreateItineraryBottomSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final context) => const InterestSelectionScreen(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return ExpandableFab(
      key: _fabKey,
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
              'AI Suggested Schedule',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              onPressed: () {
                // Close the expandable FAB
                final state = _fabKey.currentState;
                state?.toggle();
                // Show the bottom sheet
                _showCreateItineraryBottomSheet(context);
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
