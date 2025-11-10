import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FieldContainerWidget extends ConsumerWidget {
  final Widget child;

  const FieldContainerWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF3C3C3C) : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

