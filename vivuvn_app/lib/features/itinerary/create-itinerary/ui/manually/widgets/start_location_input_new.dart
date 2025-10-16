import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../../../common/validator/validator.dart';
import '../../../controller/search_provice_controller.dart';
import '../../../models/province.dart';

class StartLocationInputNew extends ConsumerStatefulWidget {
  const StartLocationInputNew({super.key});

  @override
  ConsumerState<StartLocationInputNew> createState() =>
      _StartLocationInputNewState();
}

class _StartLocationInputNewState extends ConsumerState<StartLocationInputNew> {
  late TextEditingController _controller;

  @override
  Widget build(final BuildContext context) {
    return TypeAheadField<Province>(
      hideWithKeyboard: false,
      hideOnUnfocus: false,
      builder: (final context, final controller, final focusNode) {
        _controller = controller;
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'From where?',
            hintText: 'Hà Nội',
            prefixIcon: const Icon(Icons.flight_takeoff),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (final value) =>
              Validator.notEmpty(value, fieldName: 'This field'),
        );
      },
      decorationBuilder: (final context, final child) {
        return Container(
          height: 400.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: child,
        );
      },
      itemBuilder: (final context, final province) {
        return ListTile(title: Text(province.name));
      },
      suggestionsCallback: (final searchText) => ref
          .read(searchProvinceControllerProvider.notifier)
          .searchProvince(searchText),
      onSelected: (final province) {
        _controller.text = province.name;
      },
    );
  }
}
