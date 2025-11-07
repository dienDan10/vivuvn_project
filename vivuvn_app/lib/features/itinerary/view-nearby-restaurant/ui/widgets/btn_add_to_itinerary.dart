import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../common/toast/global_toast.dart';
import '../../controller/restaurant_controller.dart';
import '../../data/model/restaurant.dart';

class ButtonAddToItinerary extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  const ButtonAddToItinerary({super.key, required this.restaurant});

  @override
  ConsumerState<ButtonAddToItinerary> createState() =>
      _ButtonAddToItineraryState();
}

class _ButtonAddToItineraryState extends ConsumerState<ButtonAddToItinerary> {
  Future<void> _handleAddToItinerary() async {
    await ref
        .read(restaurantControllerProvider.notifier)
        .addRestaurantToItinerary(widget.restaurant.id, context);
  }

  @override
  Widget build(final BuildContext context) {
    ref.listen(
      restaurantControllerProvider.select(
        (final state) => state.addToItineraryErrorMessage,
      ),
      (final previous, final next) {
        if (next != null) {
          GlobalToast.showErrorToast(context, message: next);
        }
      },
    );

    final isAdding = ref.watch(
      restaurantControllerProvider.select(
        (final state) => state.isAddingToItinerary,
      ),
    );

    return InkWell(
      onTap: isAdding ? null : _handleAddToItinerary,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isAdding
              ? Theme.of(
                  context,
                ).colorScheme.tertiaryFixed.withValues(alpha: 0.5)
              : Theme.of(context).colorScheme.tertiaryFixed,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icons or Loading Indicator
            if (isAdding)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onTertiaryFixed,
                  ),
                ),
              )
            else
              SvgPicture.asset(
                'assets/icons/add.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onTertiaryFixed,
                  BlendMode.srcIn,
                ),
              ),

            const SizedBox(width: 4),

            // Text
            Text(
              isAdding ? 'Đang thêm...' : 'Thêm vào hành trình',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onTertiaryFixed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
