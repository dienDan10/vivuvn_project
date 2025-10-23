import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/automically_generate_by_ai_controller.dart';
import 'generate_itinerary_with_AI_layout_step.dart';
import 'interest_selection_step.dart';

class StepContent extends ConsumerWidget {
  const StepContent({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(automicallyGenerateByAiControllerProvider);
    if (state.step == 1) return const Expanded(child: InterestSelectionStep());
    return Expanded(
      child: SingleChildScrollView(
        child: GenerateItineraryWithAiLayout(formKey: formKey),
      ),
    );
  }
}
