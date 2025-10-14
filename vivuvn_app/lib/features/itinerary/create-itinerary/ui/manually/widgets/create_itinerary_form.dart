import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';

import 'btn_create_itinerary.dart';
import 'date_range_picker.dart';
import 'start_location_input.dart';

class CreateItineraryForm extends StatefulWidget {
  final ScrollController scrollController;
  const CreateItineraryForm({super.key, required this.scrollController});

  @override
  State<CreateItineraryForm> createState() => _CreateItineraryFormState();
}

class _CreateItineraryFormState extends State<CreateItineraryForm> {
  late TextEditingController _fromController = TextEditingController();
  late TextEditingController _toController = TextEditingController();
  final List<DateTime?> _rangeDatePicker = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 2)),
  ];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _fromController = TextEditingController();
    _toController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // remove keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // From Input Field
          const StartLocationInput(),
          const SizedBox(height: 16),

          // To Input Field
          Material(
            color: Colors.transparent,
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Đà Nẵng',
                labelText: 'Where to go?',
                prefixIcon: const Icon(Icons.location_on, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
              ),
            ),
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
                  _submitForm();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
