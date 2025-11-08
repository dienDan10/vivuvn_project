import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'copy_invite_code_button.dart';
import 'fetch_invite_code_button.dart';
import 'invite_code_error_handler.dart';
import 'invite_code_text.dart';

class InviteCodeDisplay extends ConsumerWidget {
  const InviteCodeDisplay({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return InviteCodeErrorHandler(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: const Row(
          children: [
            FetchInviteCodeButton(),
            SizedBox(width: 12),
            InviteCodeText(),
            SizedBox(width: 8),
            CopyInviteCodeButton(),
          ],
        ),
      ),
    );
  }
}

