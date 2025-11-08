import 'package:flutter/material.dart';

class EmptyItinerary extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const EmptyItinerary({
    super.key,
    this.title = 'Lập kế hoạch theo cách của bạn',
    this.description =
        'Xây dựng chuyến đi bằng các mục đã lưu hoặc sử dụng AI để nhận đề xuất tùy chỉnh, cộng tác với bạn bè và sắp xếp ý tưởng cho chuyến đi.',
    this.icon = Icons.map_outlined,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primaryContainer.withValues(alpha: 0.3),
                colorScheme.secondaryContainer.withValues(alpha: 0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // Animated icon container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.2),
                      colorScheme.secondary.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: colorScheme.primary,
                ),
              ),

                const SizedBox(height: 32),

              // Icon row with theme colors
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIconBadge(
                    icon: Icons.favorite_rounded,
                    color: colorScheme.error,
                    context: context,
                  ),
                  const SizedBox(width: 16),
                  _buildIconBadge(
                    icon: Icons.public,
                    color: colorScheme.tertiary,
                    context: context,
                  ),
                  const SizedBox(width: 16),
                  _buildIconBadge(
                    icon: Icons.flight_takeoff_rounded,
                    color: colorScheme.primary,
                    context: context,
                  ),
                ],
              ),

                const SizedBox(height: 24),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  height: 1.3,
                ),
              ),

                const SizedBox(height: 12),

              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconBadge({
    required final IconData icon,
    required final Color color,
    required final BuildContext context,
  }) {
    // final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}
