import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/toast/global_toast.dart';
import '../../controller/profile_controller.dart';

class ProfilePictureEditButton extends ConsumerStatefulWidget {
  const ProfilePictureEditButton({super.key});

  @override
  ConsumerState<ProfilePictureEditButton> createState() =>
      _ProfilePictureEditButtonState();
}

class _ProfilePictureEditButtonState
    extends ConsumerState<ProfilePictureEditButton> {
  Future<void> _handlePickAndUpload() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);

      if (file == null || !mounted) return;

      final message = await ref
          .read(profileControllerProvider.notifier)
          .uploadAvatar(file.path);

      if (mounted) {
        GlobalToast.showSuccessToast(context, message: message);
      }
    } catch (e) {
      if (mounted) {
        GlobalToast.showErrorToast(context, message: e.toString());
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isLoading = ref.watch(
      profileControllerProvider.select((final s) => s.isLoading),
    );

    if (isLoading) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: _handlePickAndUpload,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primary,
            border: Border.all(
              color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
              width: 3,
            ),
          ),
          child: const Icon(
            Icons.camera_alt_outlined,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

