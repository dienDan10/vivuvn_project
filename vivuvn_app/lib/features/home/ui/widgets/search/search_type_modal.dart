import 'package:flutter/material.dart';

class SearchTypeModal extends StatelessWidget {
  const SearchTypeModal({super.key});

  static Future<String?> show(final BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (final context) => const SearchTypeModal(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final isSmallScreen = screenHeight < 700 || screenWidth < 360;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.5,
        minHeight: isSmallScreen ? 200 : 250,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: isSmallScreen ? 8 : 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(height: isSmallScreen ? 12 : 20),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
              ),
              child: Text(
                'Bạn muốn tìm kiếm gì?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 18 : null,
                ),
              ),
            ),

            SizedBox(height: isSmallScreen ? 12 : 20),

            // Option 1: Search Places
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
              ),
              child: _SearchOptionCard(
                icon: Icons.place,
                title: 'Địa điểm du lịch',
                description: 'Tìm kiếm các địa điểm du lịch hấp dẫn',
                color: colorScheme.primary,
                onTap: () => Navigator.of(context).pop('places'),
                isSmallScreen: isSmallScreen,
              ),
            ),

            SizedBox(height: isSmallScreen ? 12 : 16),

            // Option 2: Search Itineraries
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
              ),
              child: _SearchOptionCard(
                icon: Icons.map,
                title: 'Lịch trình du lịch',
                description: 'Khám phá các lịch trình từ cộng đồng',
                color: colorScheme.secondary,
                onTap: () => Navigator.of(context).pop('itineraries'),
                isSmallScreen: isSmallScreen,
              ),
            ),

            SizedBox(height: isSmallScreen ? 12 : 20),
          ],
        ),
      ),
    );
  }
}

class _SearchOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final bool isSmallScreen;

  const _SearchOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    required this.isSmallScreen,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconSize = isSmallScreen ? 40.0 : 56.0;
    final iconInnerSize = isSmallScreen ? 20.0 : 28.0;
    final padding = isSmallScreen ? 12.0 : 20.0;
    final spacing = isSmallScreen ? 12.0 : 16.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: iconInnerSize),
            ),

            SizedBox(width: spacing),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 14 : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isSmallScreen ? 2 : 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontSize: isSmallScreen ? 11 : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              size: isSmallScreen ? 14 : 16,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
