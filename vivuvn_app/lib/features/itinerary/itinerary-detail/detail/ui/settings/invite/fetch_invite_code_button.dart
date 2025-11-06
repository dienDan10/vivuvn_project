import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/itinerary_detail_controller.dart';

class FetchInviteCodeButton extends ConsumerWidget {
  const FetchInviteCodeButton({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isInviteCodeLoading = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.isInviteCodeLoading,
      ),
    );

    final controller = ref.read(itineraryDetailControllerProvider.notifier);

    return ElevatedButton.icon(
      onPressed: isInviteCodeLoading
          ? null
          : () {
              controller.fetchInviteCode();
            },
      icon: isInviteCodeLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.key, size: 18, color: Colors.white),
      label: const Text('Lấy mã'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        minimumSize: const Size(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

