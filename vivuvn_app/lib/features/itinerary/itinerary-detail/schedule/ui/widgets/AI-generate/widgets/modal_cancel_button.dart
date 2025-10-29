import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/automically_generate_by_ai_controller.dart';

class ModalCancelButton extends ConsumerWidget {
  const ModalCancelButton({super.key});

  void _onPressed(final WidgetRef ref, final BuildContext context) {
    final stateStep = ref.read(
      automicallyGenerateByAiControllerProvider.select((final s) => s.step),
    );
    final controller = ref.read(
      automicallyGenerateByAiControllerProvider.notifier,
    );
    if (stateStep == 0) {
      Navigator.of(context).pop();
    } else {
      controller.prevStep();
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final stateStep = ref.watch(
      automicallyGenerateByAiControllerProvider.select((final s) => s.step),
    );
    final cancelLabel = stateStep == 0 ? 'Hủy' : 'Trở về';

    return ElevatedButton(
      onPressed: () => _onPressed(ref, context),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        cancelLabel,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
