import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/itinerary/create-itinerary/controller/create_itinerary_controller.dart';
import '../features/itinerary/create-itinerary/ui/manually/create_itinerary_layout.dart';

class CreateItineraryScreen extends ConsumerWidget {
  const CreateItineraryScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isLoading = ref.watch(
      createItineraryControllerProvider.select(
        (final state) => state.isLoading,
      ),
    );
    return Stack(
      children: [
        const CreateItineraryLayout(), // Loading Overlay
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Đang tạo hành trình...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
