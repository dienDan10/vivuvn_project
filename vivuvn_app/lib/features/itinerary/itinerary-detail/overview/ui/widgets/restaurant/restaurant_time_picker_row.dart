import 'package:flutter/material.dart';

class RestaurantTimePickerRow extends StatelessWidget {
  final String label;
  final String? timeText; // HH:mm:ss
  final VoidCallback onTap;

  const RestaurantTimePickerRow({
    super.key,
    required this.label,
    required this.timeText,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(timeText),
                    style: TextStyle(
                      fontSize: 14,
                      color: timeText != null ? Colors.black : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.access_time, color: Color(0xFFBDBDBD), size: 20),
          ],
        ),
      ),
    );
  }

  String _formatTime(final String? t) {
    if (t == null || t.isEmpty) return 'Chọn giờ';
    // Expect HH:mm:ss; display HH:mm
    final parts = t.split(':');
    if (parts.length < 2) return 'Chọn giờ';
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }
}


