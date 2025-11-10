import 'package:flutter/material.dart';

import 'change_password_field.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(final BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Current Password Field
          ChangePasswordField(
            label: 'Mật khẩu hiện tại',
            isCurrentPassword: true,
          ),
          SizedBox(height: 20),
          // New Password Field
          ChangePasswordField(
            label: 'Mật khẩu mới',
            isCurrentPassword: false,
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

