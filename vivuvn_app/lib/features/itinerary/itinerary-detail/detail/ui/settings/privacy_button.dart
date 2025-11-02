import 'package:flutter/material.dart';

class PrivacyButton extends StatefulWidget {
  const PrivacyButton({super.key});

  @override
  State<PrivacyButton> createState() => _PrivacyButtonState();
}

class _PrivacyButtonState extends State<PrivacyButton>
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

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    // Logic sẽ được thêm sau
  }

  @override
  Widget build(final BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          child: const ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Tùy chọn riêng tư'),
          ),
        ),
      ),
    );
  }
}

