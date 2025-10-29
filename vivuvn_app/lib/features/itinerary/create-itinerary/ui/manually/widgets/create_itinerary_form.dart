import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../../view-itinerary-list/controller/itinerary_controller.dart';
import '../../../controller/create_itinerary_controller.dart';
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
  void _createItinerary() async {
    final response = await ref
        .read(createItineraryControllerProvider.notifier)
        .createItinerary();
    if (response != null) {
      // move to itinerary detail page
      if (mounted) {
        context.pop(); // close create itinerary bottom sheet
        context.push(createItineraryDetailRoute(response.id));
        ref.read(itineraryControllerProvider.notifier).fetchItineraries();
      }
    }
  }

  void _listener() {
    ref.listen(
      createItineraryControllerProvider.select((final state) => state.error),
      (final previous, final next) {
        if (next != null && next.isNotEmpty) {
          // show toast error message
          GlobalToast.showErrorToast(context, message: next);
        }
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    _listener();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // From Input Field
        const SelectStartLocation(),
        const SizedBox(height: 16),

        // To Input Field
        const SelectDestinationLocation(),
        const SizedBox(height: 16),

        //Date Range Picker
        const SelectDate(),
        const SizedBox(height: 20),

        // Action buttons
        const Spacer(),
        CreateItineraryButton(onClick: _createItinerary),

        const SizedBox(height: 100),
      ],
    );
  }
}
