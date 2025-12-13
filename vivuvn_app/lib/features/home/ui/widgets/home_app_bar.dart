import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/auth/controller/auth_controller.dart';
import 'search/search_itineraries_modal.dart';
import 'search/search_places_modal.dart';
import 'search/search_type_modal.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authControllerProvider);
    final userName = authState.user?.username;

    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.35,
      floating: false,
      pinned: true,
      backgroundColor: colorScheme.primary,
      title: Row(
        children: [
          Image.asset('assets/images/app-logo.png', height: 32, width: 32),
          const SizedBox(width: 8),
          Text(
            'Vivu Việt Nam',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () => _handleSearch(context),
          ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=1200&h=600&fit=crop',
              fit: BoxFit.cover,
              errorBuilder: (final context, final error, final stackTrace) =>
                  Image.asset(
                    'assets/images/image-placeholder.jpeg',
                    fit: BoxFit.cover,
                  ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 100,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName != null
                        ? 'Xin chào, $userName! 👋'
                        : 'Xin chào! 👋',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Khám phá những điểm đến tuyệt vời',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSearch(final BuildContext context) async {
    final result = await SearchTypeModal.show(context);
    if (result != null && context.mounted) {
      if (result == 'places') {
        await showSearchPlacesModal(context);
      } else if (result == 'itineraries') {
        await SearchItinerariesModal.show(context);
      }
    }
  }
}
