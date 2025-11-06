import 'package:flutter/material.dart';

import 'invite_modal_back_button.dart';

class InviteModalHeader extends StatelessWidget {
  const InviteModalHeader({super.key});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Row(
        children: [
          const InviteModalBackButton(),
          Expanded(
            child: Text(
              'Mời tham gia',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balance back button width
        ],
      ),
    );
  }
}

