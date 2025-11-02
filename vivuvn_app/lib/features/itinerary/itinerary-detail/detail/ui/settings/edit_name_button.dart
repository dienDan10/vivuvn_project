import 'package:flutter/material.dart';

class EditNameButton extends StatefulWidget {
  const EditNameButton({super.key});

  @override
  State<EditNameButton> createState() => _EditNameButtonState();
}

class _EditNameButtonState extends State<EditNameButton>
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
            leading: Icon(Icons.edit),
            title: Text('Sửa tên hành trình'),
          ),
        ),
      ),
    );
  }
}

