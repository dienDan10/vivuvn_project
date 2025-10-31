import 'package:flutter/material.dart';

class ButtonSettings extends StatelessWidget {
  final bool onAppbar;
  const ButtonSettings({super.key, this.onAppbar = false});

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: !onAppbar
              ? Theme.of(context).colorScheme.primary
              : Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.settings,
          color: !onAppbar
              ? Colors.white
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
