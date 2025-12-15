import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../schedule/controller/automically_generate_by_ai_controller.dart';

class AiGenerationWarningsModal extends ConsumerStatefulWidget {
  const AiGenerationWarningsModal({super.key});

  @override
  ConsumerState<AiGenerationWarningsModal> createState() =>
      _AiGenerationWarningsModalState();
}

class _AiGenerationWarningsModalState
    extends ConsumerState<AiGenerationWarningsModal> {
  @override
  Widget build(final BuildContext context) {
    final warnings = ref.watch(aiGenerationWarningsProvider);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (final didPop, final result) {
        // Clear warnings when modal is dismissed (swipe down or back button)
        if (didPop) {
          ref.read(aiGenerationWarningsProvider.notifier).state = [];
        }
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Cảnh báo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  // Clear warnings when closing
                  ref.read(aiGenerationWarningsProvider.notifier).state = [];
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          // Warnings list
          if (warnings.isNotEmpty)
            ...warnings.map((final warning) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          warning,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          const SizedBox(height: 16),
          // Close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Clear warnings when closing
                ref.read(aiGenerationWarningsProvider.notifier).state = [];
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Đã hiểu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

