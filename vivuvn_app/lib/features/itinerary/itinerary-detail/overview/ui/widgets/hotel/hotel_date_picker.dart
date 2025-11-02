import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HotelDatePicker extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const HotelDatePicker({
    super.key,
    required this.label,
    required this.date,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              date != null
                  ? DateFormat('dd/MM/yyyy').format(date!)
                  : 'Chọn ngày',
              style: TextStyle(
                fontSize: 14,
                color: date != null ? Colors.black : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
