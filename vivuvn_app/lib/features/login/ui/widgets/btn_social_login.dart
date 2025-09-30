import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonSocialLogin extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const ButtonSocialLogin({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 7,
            ),
          ],
        ),
        child: Row(
          spacing: 50,
          children: [
            SvgPicture.asset(imagePath, width: 25),
            Text(
              'Continue with Google',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
