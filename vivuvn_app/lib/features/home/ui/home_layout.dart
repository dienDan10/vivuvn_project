import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/auth/controller/auth_controller.dart';
import 'widgets/home_appbar.dart';
import 'widgets/popular_destinations.dart';
import 'widgets/public_itineraries.dart';

class HomeLayout extends ConsumerStatefulWidget {
  const HomeLayout({super.key});

  @override
  ConsumerState<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends ConsumerState<HomeLayout> {
  final PageController _itineraryPageController = PageController(
    viewportFraction: 0.9,
    initialPage: 1000,
  );
  Timer? _itineraryTimer;

  @override
  void initState() {
    super.initState();
    _startItineraryAutoScroll();
  }

  void _startItineraryAutoScroll() {
    _itineraryTimer = Timer.periodic(const Duration(seconds: 4), (final timer) {
      if (_itineraryPageController.hasClients) {
        final currentPage = _itineraryPageController.page?.toInt() ?? 0;
        _itineraryPageController.animateToPage(
          currentPage + 1,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _itineraryTimer?.cancel();
    _itineraryPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authControllerProvider);
    final userName = authState.user?.username ?? "Bạn";

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(
            theme: theme,
            colorScheme: colorScheme,
            userName: userName,
          ),
          // Popular destinations section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Địa điểm phổ biến',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to destinations
                    },
                    child: const Text('Xem tất cả'),
                  ),
                ],
              ),
            ),
          ),

          // Destinations carousel
          const PopularDestinations(),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Public itineraries section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lịch trình công khai gần đây',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to itineraries
                    },
                    child: const Text('Xem tất cả'),
                  ),
                ],
              ),
            ),
          ),

          // Public itineraries carousel
          PublicItineraries(controller: _itineraryPageController),

          // Travel tips section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(
                'Mẹo du lịch',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((
                final context,
                final index,
              ) {
                final tips = [
                  {
                    'icon': Icons.wallet,
                    'title': 'Lập kế hoạch ngân sách',
                    'description':
                        'Xác định ngân sách trước khi đi để tránh chi tiêu quá mức',
                    'color': Colors.green,
                  },
                  {
                    'icon': Icons.wb_sunny,
                    'title': 'Kiểm tra thời tiết',
                    'description':
                        'Theo dõi dự báo thời tiết để chuẩn bị trang phục phù hợp',
                    'color': Colors.orange,
                  },
                  {
                    'icon': Icons.medical_services,
                    'title': 'Mang theo thuốc cần thiết',
                    'description':
                        'Chuẩn bị túi thuốc y tế cơ bản cho chuyến đi',
                    'color': Colors.red,
                  },
                ];

                final tip = tips[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (tip['color'] as Color).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (tip['color'] as Color).withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          tip['icon'] as IconData,
                          color: tip['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip['title'] as String,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tip['description'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }, childCount: 3),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
