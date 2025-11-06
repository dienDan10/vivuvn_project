import 'package:flutter/material.dart';

import 'invite_modal_content.dart';
import 'invite_modal_drag_handle.dart';
import 'invite_modal_header.dart';

class InviteModalSheet extends StatelessWidget {
  final ScrollController scrollController;

  const InviteModalSheet({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Stop propagation
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const InviteModalDragHandle(),
            const InviteModalHeader(),
            InviteModalContent(scrollController: scrollController),
          ],
        ),
      ),
    );
  }
}

