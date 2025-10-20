import 'package:flutter/material.dart';

import '../../../models/interested_category.dart';

class InterestFooter extends StatelessWidget {
  final bool canProceed;
  final Set<InterestCategory> selectedInterests;
  final VoidCallback onCancel;
  final VoidCallback onNext;
  final String primaryLabel;

  const InterestFooter({
    super.key,
    required this.canProceed,
    required this.selectedInterests,
    required this.onCancel,
    required this.onNext,
    this.primaryLabel = 'Next',
  });

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(onPressed: onCancel, child: const Text('Cancel')),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: canProceed ? onNext : null,
            child: Text(
              primaryLabel,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
