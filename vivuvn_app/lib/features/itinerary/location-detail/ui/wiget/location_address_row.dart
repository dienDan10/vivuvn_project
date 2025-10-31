import 'package:flutter/material.dart';

class LocationAddressRow extends StatelessWidget {
  final String address;

  const LocationAddressRow({super.key, required this.address});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: Colors.redAccent,
            size: 22,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              address,
              style: const TextStyle(
                fontSize: 15.5,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
