import 'package:flutter/material.dart';

class SearchErrorWidget extends StatelessWidget {
  const SearchErrorWidget({required this.error, super.key});

  final Object error;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Text(
          'Lỗi: ${error.toString()}',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
