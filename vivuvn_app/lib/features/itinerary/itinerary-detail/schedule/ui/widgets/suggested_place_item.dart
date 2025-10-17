import 'package:flutter/material.dart';

class SuggestedPlaceItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SuggestedPlaceItem({super.key, required this.title, this.onTap});

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Ảnh bên trái
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.lightBlue[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, size: 28, color: Colors.white),
            ),

            const SizedBox(width: 8),

            // Tiêu đề địa điểm
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(width: 4),

            // Nút cộng
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 18, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
