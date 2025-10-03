import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../l10n/app_localizations.dart';

class ButtonGoogleLogin extends StatelessWidget {
  const ButtonGoogleLogin({super.key});

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding:
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.15),
              blurRadius: 7,
            ),
          ],
        ),
        child: Row(
          spacing: 50,
          children: [
            SvgPicture.asset('assets/images/google.svg', width: 25),
            Text(
              AppLocalizations.of(context)!.loginGoogle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}