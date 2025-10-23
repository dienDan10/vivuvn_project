import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/automically_generate_by_ai_controller.dart';

class CurrencyDropdown extends ConsumerWidget {
  const CurrencyDropdown({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ctrl = ref.read(automicallyGenerateByAiControllerProvider.notifier);
    final s = ref.watch(automicallyGenerateByAiControllerProvider);
    return DropdownButton<String>(
      value: s.currency,
      items: const [
        DropdownMenuItem(value: 'VND', child: Text('VND')),
        DropdownMenuItem(value: 'USD', child: Text('USD')),
      ],
      onChanged: (final v) => ctrl.setCurrency(v ?? 'VND'),
    );
  }
}
