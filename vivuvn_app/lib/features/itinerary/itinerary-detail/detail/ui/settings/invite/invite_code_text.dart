import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/itinerary_detail_controller.dart';

class InviteCodeText extends ConsumerWidget {
  const InviteCodeText({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Lấy inviteCode từ state hoặc từ itinerary object
    final inviteCode = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.inviteCode ?? state.itinerary?.inviteCode,
      ),
    );

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Mã mời của bạn',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                  fontSize: 11,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            inviteCode ?? 'Chưa có mã mời',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontFamily: 'monospace',
                  color: inviteCode == null
                      ? Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5)
                      : null,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

