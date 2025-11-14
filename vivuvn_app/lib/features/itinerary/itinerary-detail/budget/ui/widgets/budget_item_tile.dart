import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../detail/controller/itinerary_detail_controller.dart';
import '../../data/models/budget_items.dart';
import 'budget_item_amount.dart';
import 'budget_item_avatar.dart';
import 'budget_item_subtitle.dart';
import 'budget_item_title.dart';

/// Widget hiển thị từng item chi tiêu với swipe-to-delete
class BudgetItemTile extends ConsumerWidget {
  final BudgetItem item;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const BudgetItemTile({
    super.key,
    required this.item,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isOwner = ref.watch(
      itineraryDetailControllerProvider.select(
        (final s) => s.itinerary?.isOwner ?? false,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Slidable(
        key: ValueKey(item.id),
        endActionPane: isOwner ? _buildDeleteAction() : null,
        child: _buildItemContent(context, isOwner),
      ),
    );
  }

  /// Build swipe delete action
  ActionPane _buildDeleteAction() {
    return ActionPane(
      motion: const DrawerMotion(),
      extentRatio: 0.2,
      dismissible: DismissiblePane(onDismissed: () => onDelete?.call()),
      children: [
        SlidableAction(
          onPressed: (_) => onDelete?.call(),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Xóa',
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }

  /// Build item content with divider
  Widget _buildItemContent(final BuildContext context, final bool isOwner) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: isOwner ? onTap : null,
          contentPadding: const EdgeInsets.only(left: 0, right: 8),
          leading: BudgetItemAvatar(item: item),
          title: BudgetItemTitle(item: item),
          subtitle: BudgetItemSubtitle(item: item),
          trailing: BudgetItemAmount(item: item),
        ),
        const Divider(height: 1),
      ],
    );
  }

}
