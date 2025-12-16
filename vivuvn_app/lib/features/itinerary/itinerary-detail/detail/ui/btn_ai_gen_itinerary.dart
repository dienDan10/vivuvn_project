import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/routes.dart';
import '../../schedule/ui/widgets/AI-generate/gen_ai_modal.dart';
import '../controller/itinerary_detail_controller.dart';

class ButtonScheduleOptions extends ConsumerStatefulWidget {
  const ButtonScheduleOptions({super.key});

  @override
  ConsumerState<ButtonScheduleOptions> createState() =>
      ButtonScheduleOptionsState();
}

class ButtonScheduleOptionsState extends ConsumerState<ButtonScheduleOptions> {
  final _fabKey = GlobalKey<ExpandableFabState>();
  void _showCreateItineraryBottomSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final context) => const GenAiModal(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final isOwner = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary?.isOwner ?? false,
      ),
    );

    return ExpandableFab(
      key: _fabKey,
      overlayStyle: ExpandableFabOverlayStyle(
        color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.7),
      ),
      distance: 70,
      childrenAnimation: ExpandableFabAnimation.none,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.menu, size: 26),
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
        // View on Map option
        Row(
          children: [
            Text(
              'Xem lịch trình trên Map',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              onPressed: () {
                // Close the expandable FAB
                final state = _fabKey.currentState;
                state?.toggle();
                context.push(mapLocationRoute);
              },
              child: const Icon(Icons.map),
            ),
          ],
        ),
        // AI Generate option
        if (isOwner)
          Row(
            children: [
              Text(
                'Tạo lịch trình thông minh',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                heroTag: null,
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
                child: const Icon(Icons.auto_awesome),
              ),
            ],
          ),
      ],
    );
  }
}
