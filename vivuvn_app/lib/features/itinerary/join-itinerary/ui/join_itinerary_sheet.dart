import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/toast/global_toast.dart';
import '../controller/join_itinerary_controller.dart';
import 'join_itinerary_content.dart';
import 'widgets/join_itinerary_drag_handle.dart';
import 'widgets/join_itinerary_header.dart';

class JoinItinerarySheet extends ConsumerWidget {
  final ScrollController scrollController;

  const JoinItinerarySheet({super.key, required this.scrollController});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // listen error toasts
    ref.listen(
      joinItineraryControllerProvider.select((final s) => s.error),
      (final previous, final next) {
        if (next != null && next.isNotEmpty) {
          GlobalToast.showErrorToast(context, message: next);
        }
      },
    );

    final isLoading = ref.watch(
      joinItineraryControllerProvider.select((final s) => s.isLoading),
    );

    return GestureDetector(
      onTap: () {}, // stop propagation
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const JoinItineraryDragHandle(),
                const JoinItineraryHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Nhập mã mời để tham gia chuyến đi cùng bạn bè!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                JoinItineraryContent(scrollController: scrollController),
              ],
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


