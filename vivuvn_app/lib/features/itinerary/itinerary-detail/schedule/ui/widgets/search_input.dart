import 'package:flutter/material.dart';

class SearchInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onQueryChanged;

  const SearchInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onQueryChanged,
  });

  @override
  Widget build(final BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      onChanged: onQueryChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Đóng',
          onPressed: () => Navigator.pop(context),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
