import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/home_controller.dart';
import 'destination_carousel.dart';
import 'empty_state_widget.dart';

class DestinationSection extends ConsumerWidget {
  const DestinationSection({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final destinations = ref.watch(
      homeControllerProvider.select((final s) => s.destinations),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
          child: Text(
            'Địa điểm phổ biến',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        destinations.isEmpty
            ? const EmptyStateWidget(
                icon: Icons.location_on_outlined,
                message: 'Không có địa điểm phổ biến',
              )
            : DestinationCarousel(destinations: destinations),
      ],
    );
  }
}
