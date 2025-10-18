import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controller/login_controller.dart';

class ButtonGoogleLogin extends ConsumerStatefulWidget {
  const ButtonGoogleLogin({super.key});

  @override
  ConsumerState<ButtonGoogleLogin> createState() => _ButtonGoogleLoginState();
}

class _ButtonGoogleLoginState extends ConsumerState<ButtonGoogleLogin> {
  Future<void> _handleGoogleLogin() async {
    await ref.read(loginControllerProvider.notifier).loginWithGoogle();
  }

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: _handleGoogleLogin,
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
        child: Stack(
          children: [
            SvgPicture.asset('assets/images/google.svg', width: 25),
            SizedBox(
              width: double.infinity,
              child: Text(
                'Continue with Google',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
