import 'package:flutter/material.dart';

class InviteModalBackground extends StatelessWidget {
  const InviteModalBackground({super.key});

  @override
  Widget build(final BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}

