import 'package:flutter/material.dart';

import '../../model/location.dart';

class PlaceCardHeader extends StatelessWidget {
  const PlaceCardHeader({super.key, required this.location});

  final Location location;

  @override
  Widget build(final BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều dọc
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: location.photos.isNotEmpty
              ? Image.network(
                  location.photos.first,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported_outlined),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            location.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            softWrap: true, // Cho phép xuống dòng
          ),
        ),
      ],
    );
  }
}
