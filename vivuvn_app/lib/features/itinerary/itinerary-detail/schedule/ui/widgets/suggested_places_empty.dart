import 'package:flutter/material.dart';

class SuggestedPlacesEmpty extends StatelessWidget {
  const SuggestedPlacesEmpty({super.key});

  @override
  Widget build(final BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text('Chưa có địa điểm gợi ý'),
      );
}

