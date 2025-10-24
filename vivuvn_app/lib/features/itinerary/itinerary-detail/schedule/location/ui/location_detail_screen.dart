import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/location_controller.dart';
import 'wiget/location_appbar.dart';
import 'wiget/location_info_tab.dart';
import 'wiget/location_overview_tab.dart';
import 'wiget/location_photos_tab.dart';

class LocationDetailScreen extends ConsumerStatefulWidget {
  final int locationId;
  const LocationDetailScreen({super.key, required this.locationId});

  @override
  ConsumerState<LocationDetailScreen> createState() =>
      _LocationDetailScreenState();
}

class _LocationDetailScreenState extends ConsumerState<LocationDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _scrollController.addListener(() {
      final newShowTitle = _scrollController.offset > 100;
      if (newShowTitle != _showTitle) setState(() => _showTitle = newShowTitle);
    });

    Future.microtask(() {
      ref
          .read(locationControllerProvider.notifier)
          .fetchLocationDetail(widget.locationId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(locationControllerProvider);

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state.error != null) {
      return Scaffold(
        body: Center(child: Text(state.error ?? 'Đã xảy ra lỗi')),
      );
    }

    final location = state.detail;
    if (location == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (_, final __) => [
          LocationAppBar(
            location: location,
            showTitle: _showTitle,
            tabController: _tabController,
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            LocationOverviewTab(location: location),
            LocationPhotosTab(location: location),
            LocationInfoTab(location: location),
          ],
        ),
      ),
    );
  }
}
