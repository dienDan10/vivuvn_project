import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'btn_create_itinerary.dart';
import 'select_date.dart';
import 'select_destination_location.dart';
import 'select_start_location.dart';

class CreateItineraryForm extends ConsumerStatefulWidget {
  const CreateItineraryForm({super.key});

  @override
  ConsumerState<CreateItineraryForm> createState() =>
      _CreateItineraryFormState();
}

class _CreateItineraryFormState extends ConsumerState<CreateItineraryForm> {
  // void _createItinerary() {
  //   // Handle create itinerary logic here
  //   CherryToast(
  //     title: const Text('Successful'),
  //     action: const Text('Itinerary Created'),
  //     themeColor: Colors.green,
  //   ).show(context);
  // }

  // void _listener() {
  //   // Add any listeners if needed
  // }

  @override
  Widget build(final BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // From Input Field
        SelectStartLocation(),
        SizedBox(height: 16),

        // To Input Field
        SelectDestinationLocation(),
        SizedBox(height: 16),

        //Date Range Picker
        SelectDate(),
        SizedBox(height: 20),

        // Action buttons
        Spacer(),
        CreateItineraryButton(),

        SizedBox(height: 100),
      ],
    );
  }
}
