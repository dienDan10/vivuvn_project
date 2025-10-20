import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/validator/validator.dart';
import '../../../controller/create_itinerary_controller.dart';
import '../../../models/province.dart';
import 'custom_icon_btn.dart';
import 'no_item_found.dart';

class SelectProvince extends ConsumerStatefulWidget {
  final Function(Province)? onSelected;

  const SelectProvince({super.key, this.onSelected});

  @override
  ConsumerState<SelectProvince> createState() => _SelectProvinceState();
}

class _SelectProvinceState extends ConsumerState<SelectProvince> {
  late TextEditingController _controller;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: TypeAheadField<Province>(
            hideWithKeyboard: false,
            hideOnUnfocus: false,
            debounceDuration: const Duration(milliseconds: 500),
            builder: (final context, final controller, final focusNode) {
              _controller = controller;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Back Button
                    CustomIconButton(
                      iconPath: 'assets/icons/arrow-back.svg',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      iconSize: 18,
                      size: 10,
                    ),

                    const SizedBox(width: 8.0),

                    // Input Field
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Nhập địa điểm...',
                          hintStyle: TextStyle(color: Colors.black45),
                          border: InputBorder.none,
                          filled: false,
                        ),
                        validator: (final value) =>
                            Validator.notEmpty(value, fieldName: 'This field'),
                      ),
                    ),

                    // Clear Button
                    CustomIconButton(
                      iconPath: 'assets/icons/x-mark.svg',
                      onPressed: () {
                        _controller.clear();
                      },
                      iconSize: 12,
                      size: 13,
                    ),
                  ],
                ),
              );
            },
            decorationBuilder: (final context, final child) {
              return Container(
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
                .read(createItineraryControllerProvider.notifier)
                .searchProvince(searchText),
            emptyBuilder: (final context) => const NoItemFound(),
            onSelected: (final province) {
              _controller.text = province.name;
              if (widget.onSelected != null) {
                widget.onSelected!(province);
              }
              context.pop();
            },
          ),
        ),
      ),
    );
  }
}
