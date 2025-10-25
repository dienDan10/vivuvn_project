import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonBack extends StatelessWidget {
  const ButtonBack({super.key});

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: () {
        context.pop();
      },
      child: Container(
        height: 40,
        width: 40,
        padding: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
