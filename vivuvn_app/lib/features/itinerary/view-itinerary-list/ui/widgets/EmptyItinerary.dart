import 'package:flutter/material.dart';

class EmptyItinerary extends StatelessWidget {
  const EmptyItinerary({super.key});

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Biểu tượng trái tim + máy bay
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, color: Colors.red, size: 32),
                  SizedBox(width: 12),
                  Icon(Icons.public, color: Colors.green, size: 28),
                  SizedBox(width: 12),
                  Icon(Icons.flight_takeoff, color: Colors.blue, size: 32),
                ],
              ),
              const SizedBox(height: 20),

              // Tiêu đề
              Text(
                'Lập kế hoạch theo cách của bạn với Chuyến đi…',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 12),

              // Mô tả ngắn
              Text(
                'Xây dựng chuyến đi bằng các mục đã lưu hoặc sử dụng AI để nhận đề xuất tùy chỉnh, cộng tác với bạn bè và sắp xếp ý tưởng cho chuyến đi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
