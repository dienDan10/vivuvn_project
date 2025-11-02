import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../detail/controller/itinerary_detail_controller.dart';
import 'group_size_icon.dart';
import 'group_size_info.dart';
import 'group_size_inline_editor.dart';

/// Widget hiển thị và chỉnh sửa số lượng người trong nhóm
class GroupSizeCard extends ConsumerWidget {
  const GroupSizeCard({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final itineraryState = ref.watch(itineraryDetailControllerProvider);
    final itinerary = itineraryState.itinerary;
    final isEditing = ref.watch(
      itineraryDetailControllerProvider.select((final s) => s.isGroupSizeEditing),
    );
    final isSaving = ref.watch(
      itineraryDetailControllerProvider.select((final s) => s.isGroupSizeSaving),
    );
    final draft = ref.watch(
      itineraryDetailControllerProvider.select((final s) => s.groupSizeDraft),
    );

    // Không hiển thị gì nếu chưa có dữ liệu
    if (itinerary == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const GroupSizeIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: isEditing
                ? GroupSizeInlineEditor(
                    initialValue: draft,
                    isSaving: isSaving,
                    onChanged: (final v) => ref
                        .read(itineraryDetailControllerProvider.notifier)
                        .updateGroupSizeDraft(v),
                    onCancel: () => ref
                        .read(itineraryDetailControllerProvider.notifier)
                        .cancelGroupSizeEditing(),
                    onSave: () => ref
                        .read(itineraryDetailControllerProvider.notifier)
                        .saveGroupSize(context),
                  )
                : GroupSizeInfo(groupSize: itinerary.groupSize),
          ),
          if (!isEditing)
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                size: 20,
                color: Colors.grey.shade600,
              ),
              onPressed: () => ref
                  .read(itineraryDetailControllerProvider.notifier)
                  .startGroupSizeEditing(),
            ),
        ],
      ),
    );
  }
}


