import 'package:flutter/material.dart';

/// Drag handle widget ở đầu modal
class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
