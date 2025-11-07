import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/toast/global_toast.dart';
import '../../../core/routes/routes.dart';
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final context) => const EmailVerificationModal(),
    );
  }

  // Add listeners for registration and email verification state changes
  void _registerListener() {
    ref.listen(
      registerControllerProvider.select((final state) => state.registerSuccess),
      (final previous, final next) {
        if (previous != next && next) {
          _showEmailVerificationModal();
        }
      },
    );
  }

  void _emailVerificationListener() {
    ref.listen(
      registerControllerProvider.select(
        (final state) => state.verifingEmailSuccess,
      ),
      (final previous, final next) {
        if (previous != next && next) {
          context.pop(); // Close modal
          context.go(loginRoute); // Go back to login
          // display success toast
          GlobalToast.showSuccessToast(
            context,
            message: 'Xác thực email thành công! Vui lòng đăng nhập.',
          );
        }
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    _registerListener();
    _emailVerificationListener();

    final isLoading = ref.watch(
      registerControllerProvider.select((final s) => s.registering),
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: 160,
                    height: 160,
                    child: Image.asset(
                      'assets/images/app-logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Tạo tài khoản mới',
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
                        'Đã có tài khoản? ',
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
                          'Đăng nhập',
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

        if (isLoading) const LoadingOverlay(loadingText: 'Đang xử lý...'),
      ],
    );
  }
}
