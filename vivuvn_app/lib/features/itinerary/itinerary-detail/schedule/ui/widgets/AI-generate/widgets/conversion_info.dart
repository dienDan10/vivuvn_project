import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/automically_generate_by_ai_controller.dart';

class ConversionInfo extends ConsumerWidget {
  const ConversionInfo({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final s = ref.watch(automicallyGenerateByAiControllerProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1 USD ≈ 24.000 VND (ước tính)',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          if (s.convertedVnd != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '≈ ${s.convertedVnd} VND',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
