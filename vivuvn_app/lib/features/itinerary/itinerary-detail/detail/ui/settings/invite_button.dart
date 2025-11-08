import 'package:flutter/material.dart';

import 'invite/invite_modal.dart';

class InviteButton extends StatefulWidget {
  const InviteButton({super.key});

  @override
  State<InviteButton> createState() => _InviteButtonState();
}

class _InviteButtonState extends State<InviteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showInviteModal(final BuildContext context) {
    Navigator.of(context).pop(); // Đóng settings modal trước
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (final context) => const InviteModal(),
    );
  }

  void _handleTap(final BuildContext context) {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    _showInviteModal(context);
  }

  @override
  Widget build(final BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleTap(context),
          child: const ListTile(
            leading: Icon(Icons.group_add),
            title: Text('Mời tham gia'),
          ),
        ),
      ),
    );
  }
}

