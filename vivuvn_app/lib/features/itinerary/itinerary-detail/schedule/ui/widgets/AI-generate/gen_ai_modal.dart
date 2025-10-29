import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/automically_generate_by_ai_controller.dart';
import 'modal_bottom_actions.dart';
import 'modal_stepper.dart';

class GenAiModal extends ConsumerStatefulWidget {
  const GenAiModal({super.key});

  @override
  ConsumerState<GenAiModal> createState() => GenAiModalState();
}

class GenAiModalState extends ConsumerState<GenAiModal> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(
        automicallyGenerateByAiControllerProvider.notifier,
      );
      controller.attachToParent();
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top,
      ),
      child: const Column(
        children: [
          ModalStepperWidget(),
          SizedBox(height: 20),
          ModalBottomActions(),
        ],
      ),
    );
  }
}
