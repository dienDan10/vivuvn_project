import 'package:flutter/material.dart';

class GroupSizeEditButton extends StatelessWidget {
  const GroupSizeEditButton({super.key});

  @override
  Widget build(final BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.edit_outlined,
        size: 20,
        color: Colors.grey.shade600,
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chức năng chỉnh sửa sẽ được thêm sau'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}


