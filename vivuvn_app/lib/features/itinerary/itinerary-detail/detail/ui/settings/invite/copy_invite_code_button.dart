import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/toast/global_toast.dart';
import '../../../controller/itinerary_detail_controller.dart';

class CopyInviteCodeButton extends ConsumerWidget {
  const CopyInviteCodeButton({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Lấy inviteCode từ state hoặc từ itinerary object
    final inviteCode = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.inviteCode ?? state.itinerary?.inviteCode,
      ),
    );

    return IconButton(
      icon: const Icon(Icons.copy, size: 20),
      onPressed: inviteCode == null
          ? null
          : () async {
              await Clipboard.setData(ClipboardData(text: inviteCode));
              if (context.mounted) {
                GlobalToast.showSuccessToast(
                  context,
                  message: 'Đã sao chép mã mời',
                );
              }
            },
      tooltip: 'Sao chép mã',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
    );
  }
}

