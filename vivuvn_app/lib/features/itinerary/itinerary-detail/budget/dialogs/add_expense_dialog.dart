import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showAddExpenseDialog(final BuildContext context) {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  String selectedType = 'Chưa chọn';
  DateTime? selectedDate;

  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (final context) => StatefulBuilder(
      builder: (final context, final setModalState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Thêm chi phí',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.shopping_cart_outlined),
                    labelText: 'Tên chi phí',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.attach_money),
                    labelText: 'Số tiền',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.category_outlined),
                  title: Text(selectedType),
                  trailing: const Icon(Icons.arrow_drop_down),
                  onTap: () async {
                    final type = await showModalBottomSheet<String>(
                      context: context,
                      builder: (_) => ListView(
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: const Text('Ăn uống'),
                            onTap: () => Navigator.pop(context, 'Ăn uống'),
                          ),
                          ListTile(
                            title: const Text('Di chuyển'),
                            onTap: () => Navigator.pop(context, 'Di chuyển'),
                          ),
                          ListTile(
                            title: const Text('Khách sạn'),
                            onTap: () => Navigator.pop(context, 'Khách sạn'),
                          ),
                        ],
                      ),
                    );
                    if (type != null) {
                      setModalState(() => selectedType = type);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month_outlined),
                  title: Text(
                    selectedDate == null
                        ? 'Chọn ngày'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      initialDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setModalState(() => selectedDate = picked);
                    }
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity, // full width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary, // màu theo theme
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary, // màu chữ tự động tương phản
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          amountController.text.isEmpty)
                        return;
                      final expense = {
                        'name': nameController.text,
                        'amount': double.tryParse(amountController.text) ?? 0,
                        'type': selectedType,
                        'day': selectedDate == null
                            ? '—'
                            : '${selectedDate!.day}/${selectedDate!.month}',
                      };
                      Navigator.pop(context, expense);
                    },
                    child: const Text('Xong'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    ),
  );
}
