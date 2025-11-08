import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/itinerary_detail_controller.dart';

class QrCodeDescriptionText extends ConsumerWidget {
  const QrCodeDescriptionText({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Lấy inviteCode từ state hoặc từ itinerary object
    final inviteCode = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.inviteCode ?? state.itinerary?.inviteCode,
      ),
    );

    return Text(
      inviteCode != null
          ? 'Gửi QR code này cho bạn bè để tham gia hành trình'
          : 'Vui lòng lấy mã mời trước để tạo QR code',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.5),
            fontSize: 12,
          ),
      textAlign: TextAlign.center,
    );
  }
}

