import 'package:flutter/material.dart';

import 'add_place_modal_header.dart';
import 'add_place_search_field.dart';

class AddPlaceModal extends StatelessWidget {
  const AddPlaceModal({required this.itineraryId, super.key});

  final int itineraryId;

  @override
  Widget build(final BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (final context, final scrollController) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AddPlaceModalHeader(),
              const SizedBox(height: 24),
              AddPlaceSearchField(itineraryId: itineraryId),
            ],
          ),
        ),
      ),
    );
  }
}
