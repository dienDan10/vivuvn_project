import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/toast/global_toast.dart';
import '../controller/public_itinerary_controller.dart';
import 'widgets/public_itinerary_header.dart';
import 'widgets/sections/hotel_section.dart';
import 'widgets/sections/itinerary_day_list.dart';
import 'widgets/sections/restaurant_section.dart';

class PublicItineraryLayout extends ConsumerWidget {
  const PublicItineraryLayout({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(publicItineraryControllerProvider);
    final itinerary = state.itinerary;

    if (itinerary == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lịch trình')),
        body: const Center(child: Text('Không tìm thấy lịch trình')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Lịch trình'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (final String value) {
              if (value == 'join') {
                _joinItinerary(context, ref);
              }
            },
            itemBuilder: (final BuildContext context) => const <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'join',
                child: Row(
                  children: [
                    Icon(Icons.person_add, size: 20),
                    SizedBox(width: 12),
                    Text('Tham gia lịch trình'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const PublicItineraryHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async =>
                  ref.read(publicItineraryControllerProvider.notifier).loadItineraryDetail(),
              child: const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItineraryDayList(),
                    RestaurantSection(),
                    HotelSection(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _joinItinerary(final BuildContext context, final WidgetRef ref) async {
  final controller = ref.read(publicItineraryControllerProvider.notifier);
  try {
    await controller.joinItinerary();
    if (context.mounted) {
      GlobalToast.showSuccessToast(
        context,
        message: 'Đã gửi yêu cầu tham gia lịch trình',
      );
    }
  } catch (e) {
    if (context.mounted) {
      GlobalToast.showErrorToast(
        context,
        message: e.toString(),
      );
    }
  }
}

