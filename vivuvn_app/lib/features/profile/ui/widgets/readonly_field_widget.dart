import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'field_container_widget.dart';
import 'readonly_field_content.dart';

class ReadOnlyFieldWidget extends ConsumerWidget {
  final String label;
  final String value;
  final IconData icon;

  const ReadOnlyFieldWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return FieldContainerWidget(
      child: ReadOnlyFieldContent(
        label: label,
        value: value,
        icon: icon,
      ),
    );
  }
}

