import 'package:flutter/material.dart';

import 'invite_modal_background.dart';
import 'invite_modal_sheet.dart';

class InviteModal extends StatelessWidget {
  const InviteModal({super.key});

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: [
        const InviteModalBackground(),
        // Modal content
        DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (final context, final scrollController) {
            return InviteModalSheet(scrollController: scrollController);
          },
        ),
      ],
    );
  }
}

