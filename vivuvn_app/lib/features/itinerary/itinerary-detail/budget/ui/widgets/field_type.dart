import 'package:flutter/material.dart';

class FieldType extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String?> onSelected;

  const FieldType({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  Future<void> _pickType(final BuildContext context) async {
    final type = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: const Text('Ăn uống'), onTap: () => Navigator.pop(context, 'Ăn uống')),
          ListTile(title: const Text('Di chuyển'), onTap: () => Navigator.pop(context, 'Di chuyển')),
          ListTile(title: const Text('Khách sạn'), onTap: () => Navigator.pop(context, 'Khách sạn')),
        ],
      ),
    );
    onSelected(type);
  }

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.category_outlined),
      title: Text(selectedType),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () => _pickType(context),
    );
  }
}
