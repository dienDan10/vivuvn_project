import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String iconPath;
  final double? iconSize;
  final double? size;
  const CustomIconButton({
    super.key,
    this.onPressed,
    required this.iconPath,
    this.iconSize = 24,
    this.size = 14,
  });

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(size ?? 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(40),
        ),
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: SvgPicture.asset(
            iconPath,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
