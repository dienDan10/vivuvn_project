import 'package:flutter/material.dart';

class GetInviteCodeButton extends StatelessWidget {
  const GetInviteCodeButton({super.key});

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Logic lấy mã mời sẽ được thêm sau
        },
        icon: const Icon(Icons.key),
        label: const Text('Lấy mã mời'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

