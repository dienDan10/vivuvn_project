import 'package:flutter/material.dart';

import 'province_autocomplete_field.dart';

class StartLocationInput extends StatelessWidget {
  const StartLocationInput({super.key});

  @override
  Widget build(final BuildContext context) {
    return const ProvinceAutocompleteField(
      labelText: 'From where?',
      hintText: 'Hà Nội',
      prefixIcon: Icons.flight_takeoff,
      debounceTag: 'start-location-search',
    );
  }
}
