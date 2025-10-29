import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/helper/app_constants.dart';
import '../../../../core/routes/routes.dart';
import '../controller/itinerary_detail_controller.dart';
import 'btn_back.dart';
import 'btn_settings.dart';

class ExpandedAppbarBackground extends ConsumerWidget {
  const ExpandedAppbarBackground({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final itinerary = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary!,
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        // Ảnh hành trình với gradient overlay
        DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Image.network(
            itinerary.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (final context, final error, final stackTrace) =>
                Image.asset(
                  'assets/images/images-placeholder.jpeg',
                  fit: BoxFit.cover,
                ),
          ),
        ),

        // Nút back và settings
        Positioned(
          top: MediaQuery.of(context).padding.top + 7,
          left: 12,
          right: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonBack(onTap: () => context.go(itineraryRoute)),
              const ButtonSettings(),
            ],
          ),
        ),

        // Tên & ngày hành trình
        Positioned(
          top: appbarExpandedHeight * 0.4,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itinerary.name,
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_formatDate(itinerary.startDate)} → ${_formatDate(itinerary.endDate)}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(final DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}
