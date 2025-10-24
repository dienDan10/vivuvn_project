import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/automically_generate_by_ai_controller.dart';
import 'interest_grid.dart';

class InterestSelectionStep extends ConsumerWidget {
  const InterestSelectionStep({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final maxSelection = ref.watch(
      automicallyGenerateByAiControllerProvider.select(
        (final s) => s.maxSelection,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title and description
        const Text(
          'Hãy chọn những sở thích của bạn',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Chọn tối đa $maxSelection danh mục để nhận được gợi ý tốt nhất.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 30),

        // Grid
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: const InterestGrid(),
        ),
      ],
    );
  }
}
