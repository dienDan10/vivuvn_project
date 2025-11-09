import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/auth/controller/auth_controller.dart';
import 'change_password/change_password_modal.dart';
import 'profile_menu_item.dart';

class ProfileMenuItems extends ConsumerWidget {
  const ProfileMenuItems({super.key});

  void _logout(final WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Change Password
          ProfileMenuItem(
            icon: Icons.lock_outline,
            title: 'Đổi mật khẩu',
            onTap: () {
              ChangePasswordModal.show(context);
            },
            showArrow: true,
          ),
          const SizedBox(height: 16),
          // Logout
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Đăng xuất',
            onTap: () {
              _logout(ref);
            },
            showArrow: false,
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

