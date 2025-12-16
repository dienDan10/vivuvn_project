import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/itinerary_detail_controller.dart';
import 'btn_back.dart';
import 'btn_settings.dart';
import 'widgets/collapsed_name_input.dart';

class CollapsedAppbar extends ConsumerWidget {
  const CollapsedAppbar({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final itinerary = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary!,
      ),
    );
    final isEditing = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.isNameEditing,
      ),
    );

    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 12,
        right: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ButtonBack(onAppbar: true),
          Expanded(
            child: isEditing
                ? const CollapsedNameInput()
                : Text(
                    itinerary.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
          const ButtonSettings(onAppbar: true),
        ],
      ),
    );
  }
}
