import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/routes/routes.dart';
import '../btn_back.dart';
import '../btn_settings.dart';

class ItineraryAppbarButtons extends ConsumerWidget {
  const ItineraryAppbarButtons({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Positioned(
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
    );
  }
}

