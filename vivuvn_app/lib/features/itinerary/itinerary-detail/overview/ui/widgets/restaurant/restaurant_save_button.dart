import 'package:flutter/material.dart';

class RestaurantSaveButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onPressed;
  final bool isEditMode;

  const RestaurantSaveButton({
    super.key,
    required this.enabled,
    required this.onPressed,
    required this.isEditMode,
  });

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(isEditMode ? 'Cập nhật' : 'Thêm'),
      ),
    );
  }
}
