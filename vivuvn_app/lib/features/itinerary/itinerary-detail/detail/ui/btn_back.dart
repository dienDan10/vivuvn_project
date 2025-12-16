import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonBack extends StatelessWidget {
  final bool onAppbar;
  final VoidCallback? onTap;

  const ButtonBack({super.key, this.onAppbar = false, this.onTap});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap ?? () => context.pop(),
      child: Container(
        height: 40,
        width: 40,
        padding: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          color: !onAppbar
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_sharp,
          color: !onAppbar
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.primary,
        ),
      ),
    );
  }
}
