import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/toast/global_toast.dart';
import '../controller/member_controller.dart';

class SendNotificationSheet extends ConsumerStatefulWidget {
  const SendNotificationSheet({super.key});

  @override
  ConsumerState<SendNotificationSheet> createState() =>
      _SendNotificationSheetState();
}

class _SendNotificationSheetState extends ConsumerState<SendNotificationSheet> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _sendEmail = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _onSend(final bool sendEmail) async {
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    await ref
        .read(memberControllerProvider.notifier)
        .sendNotificationToAllMembers(
          title,
          message,
          sendEmail: sendEmail,
          context: context,
        );
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen(
      memberControllerProvider.select(
        (final state) => state.sendingNotificationError,
      ),
      (final previous, final next) {
        if (next != null) {
          GlobalToast.showErrorToast(context, message: next);
        }
      },
    );

    final isSending = ref.watch(
      memberControllerProvider.select(
        (final state) => state.isSendingNotification,
      ),
    );

    return AbsorbPointer(
      absorbing: isSending,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.notifications_active, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Gửi thông báo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: isSending ? null : () => context.pop(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Title Field
              Opacity(
                opacity: isSending ? 0.5 : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.12),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    enabled: !isSending,
                    decoration: InputDecoration(
                      labelText: 'Tiêu đề',
                      hintText: 'Nhập tiêu đề thông báo',
                      filled: false,
                      prefixIcon: Icon(
                        Icons.title,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: InputBorder.none,
                    ),
                    validator: (final value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập tiêu đề';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Message Field
              Opacity(
                opacity: isSending ? 0.5 : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.12),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _messageController,
                    enabled: !isSending,
                    decoration: InputDecoration(
                      labelText: 'Nội dung',
                      hintText: 'Nhập nội dung thông báo',
                      prefixIcon: Icon(
                        Icons.message,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: InputBorder.none,
                      filled: false,
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                    validator: (final value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập nội dung';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Send Email Switch
              Opacity(
                opacity: isSending ? 0.5 : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    title: const Text('Gửi qua email'),
                    subtitle: const Text(
                      'Thành viên sẽ nhận thông báo qua email',
                    ),
                    value: _sendEmail,
                    onChanged: isSending
                        ? null
                        : (final value) {
                            setState(() {
                              _sendEmail = value;
                            });
                          },
                    secondary: const Icon(Icons.email),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Send Button
              ElevatedButton.icon(
                onPressed: isSending
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _onSend(_sendEmail);
                        }
                      },
                icon: isSending
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Icon(Icons.send, color: colorScheme.onPrimary),
                label: Text(isSending ? 'Đang gửi...' : 'Gửi thông báo'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: isSending
                      ? colorScheme.primary.withValues(alpha: 0.5)
                      : colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  disabledBackgroundColor: colorScheme.primary.withValues(
                    alpha: 0.5,
                  ),
                  disabledForegroundColor: colorScheme.onPrimary,
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
