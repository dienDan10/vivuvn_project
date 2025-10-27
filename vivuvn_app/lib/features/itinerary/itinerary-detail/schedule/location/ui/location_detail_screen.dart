import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ui/widgets/place_action_button_direction.dart';
import '../../ui/widgets/place_action_button_location.dart';
import '../../ui/widgets/place_action_button_website.dart';
import '../controller/location_controller.dart';
import 'wiget/location_address_row.dart';
import 'wiget/location_description.dart';
import 'wiget/location_image_slider.dart';
import 'wiget/location_rating_section.dart';

class LocationDetailScreen extends ConsumerStatefulWidget {
  final int locationId;

  const LocationDetailScreen({super.key, required this.locationId});

  @override
  ConsumerState<LocationDetailScreen> createState() =>
      _LocationDetailScreenState();
}

class _LocationDetailScreenState extends ConsumerState<LocationDetailScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch dữ liệu location khi mở màn
    Future.microtask(() {
      ref
          .read(locationControllerProvider.notifier)
          .fetchLocationDetail(widget.locationId);
    });
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(locationControllerProvider);

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state.error != null) {
      return Scaffold(body: Center(child: Text(state.error!)));
    }

    final location = state.detail;
    if (location == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final photos = location.photos;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider dùng carousel_slider
            LocationImageSlider(
              photos: photos,
              currentIndex: _currentIndex,
              onPageChanged: (final index, final reason) {
                setState(() => _currentIndex = index);
              },
              onBackPressed: () => Navigator.pop(context),
            ),

            const SizedBox(height: 20),

            ///  Tên địa điểm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                location.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 10),

            ///  Rating section
            LocationRatingSection(
              rating: location.rating,
              ratingCount: location.ratingCount,
            ),
            const SizedBox(height: 10),

            ///  Địa chỉ
            LocationAddressRow(address: location.address),
            const SizedBox(height: 20),

            ///  Các nút hành động
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  PlaceActionButtonDirection(),
                  SizedBox(width: 16),
                  PlaceActionButtonLocation(),
                  SizedBox(width: 16),
                  PlaceActionButtonWebsite(),
                ],
              ),
            ),

            const SizedBox(height: 32),

            ///  Mô tả
            LocationDescription(description: location.description),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
