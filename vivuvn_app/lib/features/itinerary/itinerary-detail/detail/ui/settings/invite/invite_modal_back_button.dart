import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../controller/itinerary_detail_controller.dart';
import '../settings_modal.dart';

class InviteModalBackButton extends ConsumerWidget {
  const InviteModalBackButton({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop(); // Đóng invite modal
        // Hiển thị lại settings modal
        final navigatorContext = context;
        
        // Lấy itineraryId từ controller hoặc route parameter
        final itineraryIdFromController = ref.read(itineraryDetailControllerProvider).itineraryId;
        int? itineraryId = itineraryIdFromController;
        
        // Fallback: thử lấy từ route parameter nếu controller chưa có
        if (itineraryId == null) {
          try {
            final route = GoRouterState.of(navigatorContext);
            final itineraryIdParam = route.pathParameters['id'];
            itineraryId = itineraryIdParam != null ? int.tryParse(itineraryIdParam) : null;
          } catch (_) {
            // Nếu không lấy được từ route, dùng null
          }
        }
        
        Future.delayed(const Duration(milliseconds: 100), () {
          if (navigatorContext.mounted) {
            showModalBottomSheet(
              context: navigatorContext,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              isDismissible: true,
              enableDrag: true,
              barrierColor: Colors.black.withValues(alpha: 0.3),
              builder: (final modalContext) => SettingsModal(
                itineraryId: itineraryId,
                parentContext: navigatorContext, // Truyền context của detail screen
              ),
            );
          }
        });
      },
    );
  }
}

