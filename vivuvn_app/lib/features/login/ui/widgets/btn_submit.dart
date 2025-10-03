import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/login_controller.dart';

class ButtonSubmit extends ConsumerWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonSubmit({super.key, required this.text, required this.onPressed});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isLoading = ref.watch(
      loginControllerProvider.select((final state) => state.isLoading),
    );

    return InkWell(
      onTap: isLoading ? null : onPressed,

      // Handle button tap
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: isLoading
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              : Text(
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
