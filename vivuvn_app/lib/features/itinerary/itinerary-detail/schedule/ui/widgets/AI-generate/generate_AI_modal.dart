// ...existing code...
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../common/toast/global_toast.dart';
import '../../../../../../../core/routes/routes.dart';
import '../../../controller/automically_generate_by_ai_controller.dart';
import 'widgets/generate_itinerary_with_AI_layout_step.dart';
import 'widgets/interest_selection_step.dart';
import 'widgets/modal_footer.dart';

class InterestSelectionScreen extends ConsumerStatefulWidget {
  const InterestSelectionScreen({super.key});

  @override
  ConsumerState<InterestSelectionScreen> createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState
    extends ConsumerState<InterestSelectionScreen> {
  final GlobalKey<FormState> _generateFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Attach to parent schedule controller after first frame so that
    // `automicallyGenerateByAiController` has the itineraryId available in
    // its state for the UI.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(
        automicallyGenerateByAiControllerProvider.notifier,
      );
      controller.attachToParent();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final controller = ref.read(
      automicallyGenerateByAiControllerProvider.notifier,
    );
    final state = ref.watch(automicallyGenerateByAiControllerProvider);

    // For step 1 (selection) we require at least one interest.
    // For step 2 (form) additionally require that itineraryId is known and
    // that we're not currently loading.
    final bool canProceed = state.step == 1
        ? state.selectedInterests.isNotEmpty
        : state.selectedInterests.isNotEmpty &&
              state.itineraryId != null &&
              !state.isLoading;
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (final context, final scrollController) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Back arrow when on step 2
              if (state.step == 2)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => controller.prevStep(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),

              // dynamic content per step
              if (state.step == 1)
                Expanded(
                  child: InterestSelectionStep(
                    scrollController: scrollController,
                    selectedInterests: state.selectedInterests,
                    onToggle: controller.toggleInterest,
                    maxSelection: state.maxSelection,
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: GenerateItineraryWithAiLayout(
                      selectedInterests: state.selectedInterests
                          .map((final e) => e.name)
                          .toList(),
                      formKey: _generateFormKey,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Footer buttons (Cancel and Next/Generate)
              InterestFooter(
                canProceed: canProceed,
                selectedInterests: state.selectedInterests,
                onCancel: () => Navigator.of(context).maybePop(),
                primaryLabel: state.step == 2 ? 'Generate' : 'Next',
                isLoading: state.isLoading,
                onNext: () async {
                  if (state.step == 1) {
                    controller.nextStep();
                    return;
                  }

                  // Validate form fields before generating
                  final form = _generateFormKey.currentState;
                  if (form == null || !form.validate()) {
                    CherryToast.error(
                      title: const Text('Validation failed'),
                      description: const Text(
                        'Please fix the highlighted fields.',
                      ),
                      displayCloseButton: false,
                      toastPosition: Position.top,
                    ).show(context);
                    return;
                  }

                  // Step == 2: trigger AI generation using controller
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (final ctx) => const AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Generating itinerary...'),
                        ],
                      ),
                    ),
                  );

                  await controller.submitGenerate();

                  // Close progress dialog
                  Navigator.of(context).pop(); // close progress dialog

                  // Show toast depending on result
                  final newState = ref.read(
                    automicallyGenerateByAiControllerProvider,
                  );

                  if (newState.isGenerated == true) {
                    GlobalToast.showSuccessToast(
                      context,
                      message: 'Itinerary generated successfully',
                    );
                    Navigator.of(
                      context,
                    ).maybePop(); // close sheet/modal on success
                    final id = newState.itineraryId;
                    if (id != null && mounted) {
                      context.go(createItineraryDetailRoute(id));
                    }
                  } else {
                    // Show error (or informational) toast
                    GlobalToast.showErrorToast(
                      context,
                      message:
                          newState.error ?? 'Generation did not return data.',
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
