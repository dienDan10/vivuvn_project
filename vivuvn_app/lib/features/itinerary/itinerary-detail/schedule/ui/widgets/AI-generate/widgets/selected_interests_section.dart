import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/automically_generate_by_ai_controller.dart';

class SelectedInterestsSection extends ConsumerWidget {
  const SelectedInterestsSection({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final s = ref.watch(automicallyGenerateByAiControllerProvider);
    final names = s.selectedInterests.map((final e) => e.name).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Interests:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: names.map((final e) => Chip(label: Text(e))).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
