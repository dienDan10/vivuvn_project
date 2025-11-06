import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../update-itinerary/controller/update_itinerary_controller.dart';
import '../../controller/itinerary_detail_controller.dart';

class PrivacyButton extends ConsumerWidget {
  const PrivacyButton({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isPublic = ref.watch(itineraryDetailControllerProvider)
            .itinerary?.isPublic ??
        false;
    final isLoading = ref.watch(updateItineraryControllerProvider).isLoading;

    return ListTile(
      leading: Icon(
        isPublic ? Icons.public : Icons.lock_outline,
      ),
      title: Text(isPublic ? 'Công khai' : 'Riêng tư'),
      trailing: Switch(
        value: isPublic,
        onChanged: isLoading
            ? null
            : (final value) {
                ref
                    .read(itineraryDetailControllerProvider.notifier)
                    .updatePrivacyStatus(context, value);
              },
      ),
    );
  }
}

