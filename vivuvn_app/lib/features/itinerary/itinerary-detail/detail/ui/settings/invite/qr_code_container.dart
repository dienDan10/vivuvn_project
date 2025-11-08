import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/itinerary_detail_controller.dart';
import 'qr_code_image.dart';
import 'qr_code_placeholder.dart';

class QrCodeContainer extends ConsumerWidget {
  const QrCodeContainer({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Lấy inviteCode từ state hoặc từ itinerary object
    final inviteCode = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.inviteCode ?? state.itinerary?.inviteCode,
      ),
    );

    return Container(
      constraints: const BoxConstraints(
        minHeight: 180,
        maxHeight: 250,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: inviteCode != null
              ? QrCodeImage(data: inviteCode)
              : const QrCodePlaceholder(),
        ),
      ),
    );
  }
}

