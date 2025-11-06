import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/join_itinerary_controller.dart';
import 'join_action_button_wrapper.dart';

class JoinItineraryForm extends ConsumerStatefulWidget {
  const JoinItineraryForm({super.key});

  @override
  ConsumerState<JoinItineraryForm> createState() => _JoinItineraryFormState();
}

class _JoinItineraryFormState extends ConsumerState<JoinItineraryForm> {
  final TextEditingController _inviteController = TextEditingController();

  @override
  void dispose() {
    _inviteController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    // keep controller text in sync if state changes elsewhere
    final inviteCode = ref.watch(
      joinItineraryControllerProvider.select((final s) => s.inviteCode),
    );
    if (_inviteController.text != inviteCode) {
      _inviteController.value = _inviteController.value.copyWith(
        text: inviteCode,
        selection: TextSelection.collapsed(offset: inviteCode.length),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          onTapOutside: (final event) => FocusScope.of(context).unfocus(),
          controller: _inviteController,
          onChanged: (final v) =>
              ref.read(joinItineraryControllerProvider.notifier).setInviteCode(v),
          decoration: InputDecoration(
            labelText: 'Mã mời',
            hintText: 'Nhập mã mời',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.confirmation_number_outlined),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => ref
                    .read(joinItineraryControllerProvider.notifier)
                    .scanQrAndSetInviteCode(context),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Quét QR'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: JoinActionButtonWrapper(),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// moved to widgets/join_action_button_wrapper.dart


