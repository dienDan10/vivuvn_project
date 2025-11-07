import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/register_controller.dart';

class ButtonSubmitRegister extends ConsumerWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonSubmitRegister({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isLoading = ref.watch(
      registerControllerProvider.select((final s) => s.registering),
    );

    return InkWell(
      onTap: isLoading ? null : onPressed, // chỉ disable khi đang loading
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
