import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/toast/global_toast.dart';
import '../../controller/profile_controller.dart';
import 'editable_field_widget.dart';
import 'readonly_field_widget.dart';

class ProfileInfoForm extends ConsumerStatefulWidget {
  const ProfileInfoForm({super.key});

  @override
  ConsumerState<ProfileInfoForm> createState() => _ProfileInfoFormState();
}

class _ProfileInfoFormState extends ConsumerState<ProfileInfoForm> {
  TextEditingController? _usernameController;
  TextEditingController? _phoneController;

  void _initializeControllers(final WidgetRef ref) {
    final user = ref.read(profileControllerProvider).user;
    _usernameController ??= TextEditingController(
      text: user?.username ?? '',
    );
    _phoneController ??= TextEditingController(
      text: user?.phoneNumber ?? '',
    );
  }

  @override
  void dispose() {
    _usernameController?.dispose();
    _phoneController?.dispose();
    super.dispose();
  }

  Future<void> _saveUsername() async {
    if (_usernameController == null) return;

    try {
      final message = await ref
          .read(profileControllerProvider.notifier)
          .updateUsername(_usernameController!.text);

      // Sync controller với state mới
      final updatedUser = ref.read(profileControllerProvider).user;
      if (updatedUser != null) {
        _usernameController!.text = updatedUser.username;
      }

      if (mounted) {
        GlobalToast.showSuccessToast(context, message: message);
      }
    } catch (e) {
      if (mounted) {
        GlobalToast.showErrorToast(context, message: e.toString());
      }
    }
  }

  void _cancelUsername() {
    ref.read(profileControllerProvider.notifier).cancelEditingUsername();
    final user = ref.read(profileControllerProvider).user;
    if (_usernameController != null) {
      _usernameController!.text = user?.username ?? '';
    }
  }

  Future<void> _savePhone() async {
    if (_phoneController == null) return;

    try {
      final message = await ref
          .read(profileControllerProvider.notifier)
          .updatePhoneNumber(_phoneController!.text);

      // Sync controller với state mới
      final updatedUser = ref.read(profileControllerProvider).user;
      if (updatedUser != null) {
        _phoneController!.text = updatedUser.phoneNumber ?? '';
      }

      if (mounted) {
        GlobalToast.showSuccessToast(context, message: message);
      }
    } catch (e) {
      if (mounted) {
        GlobalToast.showErrorToast(context, message: e.toString());
      }
    }
  }

  void _cancelPhone() {
    ref.read(profileControllerProvider.notifier).cancelEditingPhone();
    final user = ref.read(profileControllerProvider).user;
    if (_phoneController != null) {
      _phoneController!.text = user?.phoneNumber ?? '';
    }
  }

  @override
  Widget build(final BuildContext context) {
    _initializeControllers(ref);

    final profileState = ref.watch(profileControllerProvider);
    final user = profileState.user;
    final isEditingUsername = profileState.isEditingUsername;
    final isEditingPhone = profileState.isEditingPhone;

    // Sync controllers với state khi không đang edit
    if (user != null && _usernameController != null && _phoneController != null) {
      if (!isEditingUsername && _usernameController!.text != user.username) {
        _usernameController!.text = user.username;
      }
      if (!isEditingPhone && _phoneController!.text != (user.phoneNumber ?? '')) {
        _phoneController!.text = user.phoneNumber ?? '';
      }
    }

    if (_usernameController == null || _phoneController == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          EditableFieldWidget(
            label: 'Tên người dùng',
            value: user?.username ?? '',
            controller: _usernameController!,
            icon: Icons.person_outline,
            isEditing: isEditingUsername,
            onTap: () {
              ref.read(profileControllerProvider.notifier).startEditingUsername();
              if (_usernameController != null) {
                _usernameController!.text = user?.username ?? '';
              }
            },
            onCancel: _cancelUsername,
            onSave: _saveUsername,
          ),
          const SizedBox(height: 16),
          ReadOnlyFieldWidget(
            label: 'Email',
            value: user?.email ?? '',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          EditableFieldWidget(
            label: 'Số điện thoại',
            value: user?.phoneNumber ?? '',
            controller: _phoneController!,
            icon: Icons.phone_outlined,
            isEditing: isEditingPhone,
            keyboardType: TextInputType.phone,
            onTap: () {
              ref.read(profileControllerProvider.notifier).startEditingPhone();
              if (_phoneController != null) {
                _phoneController!.text = user?.phoneNumber ?? '';
              }
            },
            onCancel: _cancelPhone,
            onSave: _savePhone,
          ),
        ],
      ),
    );
  }
}
