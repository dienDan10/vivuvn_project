import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../common/theme/app_theme.dart';
import '../../../core/routes/routes.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/btn_google_login.dart';
import 'widgets/login_form.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = Theme.of(context).extension<GradientBackground>();

    return Container(
      decoration: gradient != null
          ? BoxDecoration(
        gradient: LinearGradient(
          colors: gradient.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      )
          : null,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Logo + animation
                            // Logo + animation
                            Padding(
                              padding: const EdgeInsets.only(top: 60, bottom: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Ảnh logo
                                  Image.asset(
                                    'assets/intro/logo1.png',
                                    height: 70,
                                    width: 70,
                                  ),

                                  const SizedBox(width: 5),

                                  // Text title
                                  Text(
                                    AppLocalizations.of(context)!.appTitle,
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .slideY(begin: -0.3, end: 0),
                            ),

                            // Title + animation
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!.loginTitle,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              )
                                  .animate()
                                  .fadeIn(delay: 300.ms, duration: 600.ms)
                                  .slideX(begin: -0.2, end: 0),
                            ),

                            const SizedBox(height: 30),

                            // Form + animation
                            const LoginForm()
                                .animate()
                                .fadeIn(delay: 500.ms, duration: 700.ms)
                                .slideY(begin: 0.2, end: 0),

                            const SizedBox(height: 40),

                            // Divider text + animation
                            Text(
                              AppLocalizations.of(context)!.loginOr,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            )
                                .animate()
                                .fadeIn(delay: 700.ms, duration: 500.ms)
                                .scale(begin: const Offset(0.9, 0.9)),

                            const SizedBox(height: 20),

                            // Google button + animation
                            const ButtonGoogleLogin()
                                .animate()
                                .fadeIn(delay: 900.ms, duration: 600.ms)
                                .slideX(begin: 0.3, end: 0),
                          ],
                        ),

                        // Footer (Sign up) + animation
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30, top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.loginNoAccount,
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
                                  AppLocalizations.of(context)!.loginSignUp,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(delay: 1200.ms)
                                    .shakeX(duration: 500.ms),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
