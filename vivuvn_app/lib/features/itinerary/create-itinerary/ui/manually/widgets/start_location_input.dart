import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/search_provice_controller.dart';
import '../../../models/province.dart';

class StartLocationInput extends ConsumerStatefulWidget {
  const StartLocationInput({super.key});

  @override
  ConsumerState<StartLocationInput> createState() => _StartLocationInputState();
}

class _StartLocationInputState extends ConsumerState<StartLocationInput> {
  void _handleUserInput(final String value) async {
    if (value.trim().isEmpty) return;

    await ref
        .read(searchProvinceControllerProvider.notifier)
        .searchProvince(value);
  }

  // register listener for error

  @override
  Widget build(final BuildContext context) {
    final isLoading = ref.watch(
      searchProvinceControllerProvider.select((final state) => state.isLoading),
    );
    final List<Province> provinces = ref.watch(
      searchProvinceControllerProvider.select((final state) => state.provinces),
    );

    return Material(
      color: Colors.transparent,
      child: TextFormField(
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Hà Nội',
          labelText: 'From where?',
          prefixIcon: const Icon(Icons.flight_takeoff, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
        ),
        onChanged: (final value) => EasyDebounce.debounce(
          'search-debounce',
          const Duration(milliseconds: 500),
          () => _handleUserInput(value),
        ),
      ),
    );
  }
}
