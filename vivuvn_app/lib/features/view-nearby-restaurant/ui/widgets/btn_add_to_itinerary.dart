import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonAddToItinerary extends StatelessWidget {
  const ButtonAddToItinerary({super.key});

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryFixed,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Icons
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
              'Thêm vào hành trình',
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
