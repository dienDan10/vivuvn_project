import 'package:flutter/material.dart';

class CreateItineraryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double width;
  final String label;

  const CreateItineraryButton({
    super.key,
    this.onPressed,
    this.width = 100,
    this.label = 'Create',
  });

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[800],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
