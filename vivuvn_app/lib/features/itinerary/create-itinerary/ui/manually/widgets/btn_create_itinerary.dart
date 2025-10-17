import 'package:flutter/material.dart';

class CreateItineraryButton extends StatelessWidget {
  final VoidCallback? onClick;

  const CreateItineraryButton({super.key, this.onClick});

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          'Tạo hành trình',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
