import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/automically_generate_by_ai_controller.dart';
import 'widgets/budget_field.dart';
import 'widgets/group_size_field.dart';
import 'widgets/interest_selection_step.dart';
import 'widgets/note_field.dart';

/// The Stepper area of the New AI modal.
/// This widget reads the controller's state directly (no props) and
/// exposes the stepper UI. The controls are hidden so the bottom
/// action widget can render consistent buttons.
class ModalStepperWidget extends ConsumerWidget {
  const ModalStepperWidget({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final stateStep = ref.watch(
      automicallyGenerateByAiControllerProvider.select(
        (final state) => state.step,
      ),
    );

    final steps = <Step>[
      Step(
        state: stateStep > 0 ? StepState.complete : StepState.indexed,
        isActive: stateStep >= 0,
        title: const Text('Sở thích'),
        content: const InterestSelectionStep(),
      ),
      Step(
        state: stateStep > 1 ? StepState.complete : StepState.indexed,
        isActive: stateStep >= 1,
        title: const Text('Ngân sách'),
        content: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [SizedBox(height: 8), BudgetField()],
            ),
          ),
        ),
      ),
      Step(
        state: stateStep > 2 ? StepState.complete : StepState.indexed,
        isActive: stateStep >= 2,
        title: const Text('Chi tiết'),
        content: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 8),
                GroupSizeField(),
                SizedBox(height: 8),
                NoteField(),
              ],
            ),
          ),
        ),
      ),
    ];

    return Expanded(
      child: Stepper(
        type: StepperType.horizontal,
        steps: steps,
        currentStep: stateStep,
        controlsBuilder: (final _, final __) => const SizedBox.shrink(),
      ),
    );
  }
}
