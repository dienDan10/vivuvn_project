import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FieldActionButtons extends ConsumerWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const FieldActionButtons({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onCancel,
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.grey.withValues(alpha: 0.15),
            splashFactory: InkSparkle.splashFactory,
          ),
          icon: const Icon(Icons.close),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: onSave,
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
            splashFactory: InkSparkle.splashFactory,
          ),
          icon: Icon(
            Icons.check,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

