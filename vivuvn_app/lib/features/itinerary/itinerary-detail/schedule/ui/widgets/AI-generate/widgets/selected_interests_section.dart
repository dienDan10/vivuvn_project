import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/automically_generate_by_ai_controller.dart';

class SelectedInterestsSection extends ConsumerWidget {
  const SelectedInterestsSection({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final s = ref.watch(automicallyGenerateByAiControllerProvider);
    // Display the Vietnamese label in the UI but keep the underlying
    // InterestCategory objects (and their `name`) intact for requests.
    final displayNames = s.selectedInterests
        .map((final e) => e.vNameseName)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Những sở thích đã chọn:',
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
          children: displayNames.map((final e) {
            return SizedBox(
              width: 100,
              height: 40,
              child: AutoSizeText(
                e,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 2,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
