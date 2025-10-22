import 'package:flutter/material.dart';

import '../../../../model/interested_category.dart';
import 'interest_grid.dart';

class InterestSelectionStep extends StatelessWidget {
  final ScrollController scrollController;
  final Set<InterestCategory> selectedInterests;
  final void Function(InterestCategory) onToggle;
  final int maxSelection;

  const InterestSelectionStep({
    super.key,
    required this.scrollController,
    required this.selectedInterests,
    required this.onToggle,
    required this.maxSelection,
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title and description
        const Text(
          'Let us know \nwhat you\'re interested in!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Choose up to $maxSelection categories to get the best suggestions.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 30),

        // Grid
        Expanded(
          child: InterestGrid(
            controller: scrollController,
            selectedInterests: selectedInterests,
            onToggle: onToggle,
          ),
        ),
      ],
    );
  }
}
