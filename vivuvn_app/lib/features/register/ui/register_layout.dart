import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../login/ui/widgets/loading_overlay.dart';
import '../controller/register_controller.dart';
import 'widgets/email_verification_modal.dart';
import 'widgets/register_form.dart';

class RegisterLayout extends ConsumerStatefulWidget {
  const RegisterLayout({super.key});

  @override
  ConsumerState<RegisterLayout> createState() => _RegisterLayoutState();
}

class _RegisterLayoutState extends ConsumerState<RegisterLayout> {
  void _showEmailVerificationModal() {
    final email =
        ref.read(registerControllerProvider).registerData['email'] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final context) => EmailVerificationModal(email: email),
    );
  }

  // Add listeners for registration and email verification state changes
  void _registerListener() {
    ref.listen(
      registerControllerProvider.select((final state) => state.isSuccess),
      (final previous, final next) {
        if (previous != next && next) {
          _showEmailVerificationModal();
        }
      },
    );
  }

  void _emailVerificationListener() {
    ref.listen(
      registerControllerProvider.select((final state) => state.isEmailVerified),
      (final previous, final next) {
        if (previous != next && next) {
          Navigator.of(context).pop(); // Close modal
          // TODO: Navigate to login or home screen
          context.pop(); // Go back to login
        }
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    _registerListener();
    _emailVerificationListener();

    final isLoading = ref.watch(
      registerControllerProvider.select((final s) => s.isLoading),
    );

    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  ),

                  // Logo and Title
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 50),
                    child: Text(
                      'Logo',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Create your Account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Register Form
                  const RegisterForm(),

                  // Back to Sign In
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        if (isLoading)
          const LoadingOverlay(loadingText: 'Registering, please wait...'),
      ],
    );
  }
}
