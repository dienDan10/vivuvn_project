import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/automically_generate_by_ai_controller.dart';
import 'widgets/_back_arrow.dart';
import 'widgets/_handle_bar.dart';
import 'widgets/_modal_footer_widget.dart';
import 'widgets/_step_content.dart';

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
              const HandleBar(),
              const SizedBox(height: 20),
              if (state.step == 2) const BackArrow(),
              StepContent(formKey: _generateFormKey),
              const SizedBox(height: 20),
              ModalFooterWidget(
                canProceed: canProceed,
                formKey: _generateFormKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
