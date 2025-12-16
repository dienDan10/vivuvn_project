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
    final theme = Theme.of(context);
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: BoxBorder.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.6),
            width: 0.6,
          ),
        ),
        child: Row(
          spacing: 20.0,
          children: [
            Icon(
              icon,
              color: theme.iconTheme.color ?? theme.colorScheme.onSurface,
            ),
            Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: theme.textTheme.bodyMedium?.color
                    ?.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
