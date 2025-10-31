import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../detail/controller/itinerary_detail_controller.dart';

/// Widget hiển thị và chỉnh sửa số lượng người trong nhóm
class GroupSizeCard extends ConsumerWidget {
  const GroupSizeCard({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final itineraryState = ref.watch(itineraryDetailControllerProvider);
    final itinerary = itineraryState.itinerary;

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
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF5B7FFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.group, size: 24, color: Color(0xFF5B7FFF)),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Số người trong đoàn',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${itinerary.groupSize} người',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Edit button (placeholder for future CRUD)
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              size: 20,
              color: Colors.grey.shade600,
            ),
            onPressed: () {
              // TODO: Implement edit group size
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng chỉnh sửa sẽ được thêm sau'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
