import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'modal_cancel_button.dart';
import 'modal_continue_button.dart';

class ModalActionsRow extends ConsumerWidget {
  const ModalActionsRow({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return const Row(
      children: [
        Expanded(child: ModalCancelButton()),
        SizedBox(width: 12),
        Expanded(child: ModalContinueButton()),
      ],
    );
  }
}
