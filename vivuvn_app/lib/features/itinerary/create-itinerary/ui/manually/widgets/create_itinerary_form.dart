import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';

import '../../../../../../screens/select_province_screen.dart';
import 'add_province_btn.dart';
import 'btn_create_itinerary.dart';
import 'date_range_picker.dart';

class CreateItineraryForm extends StatefulWidget {
  const CreateItineraryForm({super.key});

  @override
  State<CreateItineraryForm> createState() => _CreateItineraryFormState();
}

class _CreateItineraryFormState extends State<CreateItineraryForm> {
  final List<DateTime?> _rangeDatePicker = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 2)),
  ];

  void _handleSelectProvince() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (final context) => const SelectProvinceScreen(),
      ),
    );
  }

  void _createItinerary() {
    // Handle create itinerary logic here
    CherryToast(
      title: const Text('Successful'),
      action: const Text('Itinerary Created'),
      themeColor: Colors.green,
    ).show(context);
  }

  void _listener() {
    // Add any listeners if needed
  }

  @override
  Widget build(final BuildContext context) {
    _listener();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // From Input Field
        AddProvinceButton(
          icon: Icons.flight_takeoff,
          text: 'From Where?',
          onClick: _handleSelectProvince,
        ),
        const SizedBox(height: 16),

        // To Input Field
        AddProvinceButton(
          icon: Icons.flight_land,
          text: 'To Where?',
          onClick: _handleSelectProvince,
        ),
        const SizedBox(height: 16),

        //Date Range Picker
        DateRangePickerField(
          initialValue: _rangeDatePicker,
          onChanged: (final start, final end) {
            setState(() {
              _rangeDatePicker[0] = start;
              _rangeDatePicker[1] = end;
            });
          },
        ),
        const SizedBox(height: 20),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            CreateItineraryButton(
              onPressed: () {
                //Handle create
              },
            ),
          ],
        ),
      ],
    );
  }
}
