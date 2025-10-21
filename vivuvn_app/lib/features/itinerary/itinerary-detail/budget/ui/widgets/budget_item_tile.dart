import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../data/models/budget_items.dart';
import '../../utils/budget_constants.dart';
import '../../utils/budget_type_icons.dart';

/// Widget hiển thị từng item chi tiêu với swipe-to-delete
class BudgetItemTile extends StatelessWidget {
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
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Slidable(
        key: ValueKey(item.id),
        endActionPane: _buildDeleteAction(),
        child: _buildItemContent(context),
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
  Widget _buildItemContent(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.only(left: 0, right: 8),
          leading: _buildAvatar(context),
          title: _buildTitle(),
          subtitle: _buildSubtitle(),
          trailing: _buildAmount(context),
        ),
        const Divider(height: 1),
      ],
    );
  }

  /// Build avatar icon
  Widget _buildAvatar(final BuildContext context) {
    final icon = BudgetTypeIcons.getIconForType(item.budgetType);

    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
    );
  }

  /// Build item title
  Widget _buildTitle() {
    return Text(
      item.name,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
    );
  }

  /// Build item subtitle with date and type
  Widget _buildSubtitle() {
    return Text(
      '${_formatDay(item.date)} • ${item.budgetType}',
      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
    );
  }

  /// Build amount display with VND and USD
  Widget _buildAmount(final BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    final usdAmount = item.cost / BudgetConstants.exchangeRate;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${formatter.format(item.cost.round())} đ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '≈ \$${usdAmount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }

  /// Format date as day/month
  String _formatDay(final DateTime dt) => '${dt.day}/${dt.month}';
}
