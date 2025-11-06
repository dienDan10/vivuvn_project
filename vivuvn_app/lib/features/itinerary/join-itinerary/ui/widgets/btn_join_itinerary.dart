import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/join_itinerary_controller.dart';

class JoinItineraryButton extends ConsumerWidget {
  const JoinItineraryButton({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isLoading = ref.watch(
      joinItineraryControllerProvider.select((final s) => s.isLoading),
    );

    return InkWell(
      onTap: isLoading
          ? null
          : () => ref
              .read(joinItineraryControllerProvider.notifier)
              .handleJoinPressed(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tham gia',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


