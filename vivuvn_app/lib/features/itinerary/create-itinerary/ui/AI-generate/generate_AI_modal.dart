// ...existing code...
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

import '../../models/interested_category.dart';
import 'widgets/generate_itinerary_with_AI_layout_step.dart';
import 'widgets/interest_selection_step.dart';
import 'widgets/modal_footer.dart';

class InterestSelectionScreen extends StatefulWidget {
  const InterestSelectionScreen({super.key});

  @override
  State<InterestSelectionScreen> createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  final Set<InterestCategory> _selectedInterests = {};
  final int maxSelection = 3;
  int _step = 1; // start at step 1 (interest selection)
  final GlobalKey<FormState> _generateFormKey = GlobalKey<FormState>();

  void _toggleInterest(final InterestCategory interest) {
    // If already selected, remove it; otherwise try to add.
    if (_selectedInterests.contains(interest)) {
      setState(() => _selectedInterests.remove(interest));
      return;
    }

    if (_selectedInterests.length < maxSelection) {
      setState(() => _selectedInterests.add(interest));
      return;
    }

    // Already reached max selection: show a styled CherryToast warning.
    CherryToast.warning(
      title: const Text('Limit reached'),
      description: Text('You can only select up to $maxSelection interests.'),
      displayCloseButton: false,
    ).show(context);
  }

  @override
  Widget build(final BuildContext context) {
    final bool canProceed = _selectedInterests.isNotEmpty;
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
              if (_step == 2)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => setState(() => _step = 1),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),

              // dynamic content per step
              if (_step == 1)
                Expanded(
                  child: InterestSelectionStep(
                    scrollController: scrollController,
                    selectedInterests: _selectedInterests,
                    onToggle: _toggleInterest,
                    maxSelection: maxSelection,
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: GenerateItineraryWithAiLayout(
                      selectedInterests: _selectedInterests
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
                selectedInterests: _selectedInterests,
                onCancel: () => Navigator.of(context).maybePop(),
                primaryLabel: _step == 2 ? 'Generate' : 'Next',
                onNext: () async {
                  if (_step == 1) {
                    setState(() => _step = 2);
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

                  // Step == 2: trigger AI generation (mocked async flow)
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

                  // Simulate async work (replace with real AI call)
                  await Future.delayed(const Duration(seconds: 2));

                  // Close progress dialog and the modal
                  Navigator.of(context).pop(); // close progress dialog
                  Navigator.of(context).maybePop(); // close sheet/modal
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
