import 'package:flutter/material.dart';

class LocationInfoTab extends StatelessWidget {
  final dynamic location;
  const LocationInfoTab({super.key, required this.location});

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(
        location.description,
        style: const TextStyle(fontSize: 15, height: 1.5),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
