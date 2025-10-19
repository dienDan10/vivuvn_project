import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/routes.dart';
import '../controller/login_controller.dart';
import 'widgets/btn_google_login.dart';
import 'widgets/loading_overlay.dart';
import 'widgets/login_form.dart';

class LoginLayout extends ConsumerWidget {
  const LoginLayout({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isLoading = ref.watch(
      loginControllerProvider.select((final state) => state.isLoading),
    );

    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 50),
                      child: Text(
                        'Logo',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Login to your Account',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),

                    // Login Form
                    const SizedBox(height: 30),
                    const LoginForm(),
                    const SizedBox(height: 80),
                    Text(
                      '- Or sign in with -',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),

                    // Social Login Buttons
                    const SizedBox(height: 30),
                    const ButtonGoogleLogin(),
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push(registerRoute);
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (isLoading)
          const LoadingOverlay(loadingText: 'Logging in, please wait...'),
      ],
    );
  }
}
