import 'package:flutter/material.dart';

import '../features/login/ui/login_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: const LoginLayout(),
      ),
    );
  }
}
