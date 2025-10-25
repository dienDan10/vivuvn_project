import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/automically_generate_by_ai_controller.dart';
import 'widgets/modal_actions_row.dart';

class ModalBottomActions extends ConsumerWidget {
  const ModalBottomActions({super.key});

  // Navigation and submit logic is implemented inside the action widgets.

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    ref.watch(
      automicallyGenerateByAiControllerProvider.select((final s) => s.step),
    );

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: const ModalActionsRow(),
      ),
    );
  }
}
