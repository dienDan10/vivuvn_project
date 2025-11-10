import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/change_password_controller.dart';

class ChangePasswordHeader extends ConsumerWidget {
  final VoidCallback onClose;
  final VoidCallback onSave;

  const ChangePasswordHeader({
    super.key,
    required this.onClose,
    required this.onSave,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLoading = ref.watch(
      changePasswordControllerProvider.select((final state) => state.isLoading),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: isLoading ? null : onClose,
          ),
          Text(
            'Đổi mật khẩu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          TextButton(
            onPressed: isLoading ? null : onSave,
            child: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  )
                : Text(
                    'Lưu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

