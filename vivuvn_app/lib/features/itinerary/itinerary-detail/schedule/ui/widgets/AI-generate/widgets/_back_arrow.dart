import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/automically_generate_by_ai_controller.dart';

class BackArrow extends ConsumerWidget {
  const BackArrow({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final controller = ref.read(
      automicallyGenerateByAiControllerProvider.notifier,
    );
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => controller.prevStep(),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
