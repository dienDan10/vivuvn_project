import 'package:flutter/material.dart';

import 'place_card.dart';

class PlaceList extends StatelessWidget {
  const PlaceList({super.key});

  @override
  Widget build(final BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Địa điểm yêu thích',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const PlaceCard(
          title: 'Bãi biển Mỹ Khê',
          description:
              'Bãi biển Mỹ Khê là một bãi biển đẹp, nằm trên trục chính từ Bắc vào Nam. Nước biển trong xanh, sóng đánh hiền hòa, cát trắng mịn...',
        ),
        const PlaceCard(
          title: 'Cầu Rồng',
          description:
              'Cầu Rồng là biểu tượng nổi tiếng của Đà Nẵng, phun lửa và nước vào cuối tuần...',
        ),
        const SizedBox(height: 12),
        Center(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Thêm địa điểm yêu thích'),
          ),
        ),
        const SizedBox(height: 80),
      ]),
    );
  }
}
