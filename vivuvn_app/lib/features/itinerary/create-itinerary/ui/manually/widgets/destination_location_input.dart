import 'package:flutter/material.dart';

import 'province_autocomplete_field.dart';

class DestinationLocationInput extends StatelessWidget {
  const DestinationLocationInput({super.key});

  @override
  Widget build(final BuildContext context) {
    return const ProvinceAutocompleteField(
      labelText: 'Where to go?',
      hintText: 'Đà Nẵng',
      prefixIcon: Icons.location_on,
      debounceTag: 'destination-location-search',
    );
  }
}
