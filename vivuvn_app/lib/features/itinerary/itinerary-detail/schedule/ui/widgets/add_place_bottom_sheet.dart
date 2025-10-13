import 'package:flutter/material.dart';

class AddPlaceBottomSheet extends StatelessWidget {
  final String type;

  const AddPlaceBottomSheet({super.key, this.type = 'place'});

  String _getHintText() {
    switch (type) {
      case 'hotel':
        return 'Tìm khách sạn hoặc nhà nghỉ...';
      case 'restaurant':
        return 'Tìm nhà hàng hoặc quán ăn...';
      default:
        return 'Tìm kiếm tên địa điểm...';
    }
  }

  String _getHelperText() {
    switch (type) {
      case 'hotel':
        return 'Nhập tên khách sạn để thêm vào lịch trình';
      case 'restaurant':
        return 'Nhập tên nhà hàng để thêm vào lịch trình';
      default:
        return 'Nhập tên địa điểm để thêm vào lịch trình';
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // thanh nhỏ kéo lên
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // ô nhập
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: _getHintText(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getHelperText(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
