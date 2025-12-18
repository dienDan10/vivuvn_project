import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/expense_bill_controller.dart';
import '../../state/expense_bill_state.dart';
import 'field_bill_attachment.dart';

/// Wrapper có state cho phần upload + preview bill trong form chi phí.
///
/// - Dùng `ExpenseBillController` để quản lý danh sách ảnh.
/// - Chỉ xử lý chọn ảnh và hiển thị preview, chưa gửi API.
class BillAttachmentSection extends ConsumerWidget {
  final bool enabled;

  const BillAttachmentSection({super.key, this.enabled = true});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ExpenseBillState billState = ref.watch(expenseBillControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldBillAttachment(enabled: enabled),
        if (billState.error != null) ...[
          const SizedBox(height: 8),
          Text(
            billState.error!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
