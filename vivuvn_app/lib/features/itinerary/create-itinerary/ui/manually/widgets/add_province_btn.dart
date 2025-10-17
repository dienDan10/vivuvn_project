import 'package:flutter/material.dart';

class AddProvinceButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onClick;
  const AddProvinceButton({
    super.key,
    this.text = 'From Where?',
    required this.icon,
    required this.onClick,
  });

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: BoxBorder.all(color: Colors.black26, width: 0.6),
        ),
        child: Row(
          spacing: 20.0,
          children: [
            Icon(icon),
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
