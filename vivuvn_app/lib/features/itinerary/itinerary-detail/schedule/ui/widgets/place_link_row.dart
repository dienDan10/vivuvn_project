import 'package:flutter/material.dart';

class PlaceLinkRow extends StatelessWidget {
  const PlaceLinkRow({super.key, required this.url});

  final String url;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: mở bằng url_launcher
      },
      child: Row(
        children: [
          const Icon(Icons.link, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              url,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blueAccent,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
