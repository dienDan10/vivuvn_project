import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_detail_controller.dart';

class ItineraryNameDisplay extends ConsumerWidget {
  const ItineraryNameDisplay({super.key});

  double _calculateFontSize(final String text) {
    if (text.length <= 20) return 26;
    if (text.length <= 35) return 22;
    return 18;
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final name = ref.watch(
      itineraryDetailControllerProvider.select(
        (final s) => s.itinerary?.name ?? '',
      ),
    );

    final fontSize = _calculateFontSize(name);

    return Text(
      name,
      textAlign: TextAlign.left,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    );
  }
}
