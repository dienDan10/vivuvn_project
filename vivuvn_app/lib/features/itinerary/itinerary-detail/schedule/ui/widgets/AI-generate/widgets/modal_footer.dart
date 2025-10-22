import 'package:flutter/material.dart';

import '../../../../model/interested_category.dart';

class InterestFooter extends StatelessWidget {
  final bool canProceed;
  final Set<InterestCategory> selectedInterests;
  final VoidCallback onCancel;
  final VoidCallback onNext;
  final String primaryLabel;
  final bool isLoading;

  const InterestFooter({
    super.key,
    required this.canProceed,
    required this.selectedInterests,
    required this.onCancel,
    required this.onNext,
    this.primaryLabel = 'Next',
    this.isLoading = false,
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
            onPressed: (canProceed && !isLoading) ? onNext : null,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    primaryLabel,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }
}
