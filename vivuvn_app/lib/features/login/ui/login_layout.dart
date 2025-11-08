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
    final colorScheme = Theme.of(context).colorScheme;
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
                    Container(
                      width: 160,
                      height: 160,
                      margin: const EdgeInsets.only(bottom: 30, top: 50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.18),
                            colorScheme.primary.withValues(alpha: 0.06),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.14),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Image.asset(
                            'assets/images/app-logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Đăng nhập',
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
                      '- Hoặc đăng nhập bằng -',
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
                          'Chưa có tài khoản? ',
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
                            'Đăng ký',
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
          const LoadingOverlay(loadingText: 'Đang đăng nhập, vui lòng chờ...'),
      ],
    );
  }
}
