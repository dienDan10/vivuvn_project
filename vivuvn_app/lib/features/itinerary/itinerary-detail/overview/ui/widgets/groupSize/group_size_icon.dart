import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupSizeIcon extends ConsumerWidget {
  const GroupSizeIcon({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF5B7FFF).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.group, size: 24, color: Color(0xFF5B7FFF)),
    );
  }
}


