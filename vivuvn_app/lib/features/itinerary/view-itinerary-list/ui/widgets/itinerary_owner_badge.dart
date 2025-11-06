import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_itinerary_provider.dart';

class ItineraryOwnerBadge extends ConsumerWidget {
  const ItineraryOwnerBadge({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final itinerary = ref.watch(currentItineraryProvider);
    if (itinerary.isOwner) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 10,
          backgroundImage: (itinerary.owner.userPhoto != null && itinerary.owner.userPhoto!.isNotEmpty)
              ? NetworkImage(itinerary.owner.userPhoto!)
              : null,
          child: (itinerary.owner.userPhoto == null || itinerary.owner.userPhoto!.isEmpty)
              ? const Icon(Icons.person, size: 14)
              : null,
        ),
        const SizedBox(width: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 180),
          child: Text(
            itinerary.owner.email,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}


