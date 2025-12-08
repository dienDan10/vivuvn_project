import 'package:flutter/material.dart';

class TravelTipsHardcodedSection extends StatelessWidget {
  const TravelTipsHardcodedSection({super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            'Mẹo du lịch',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildTipItem(
                context,
                icon: Icons.wallet,
                title: 'Lập kế hoạch ngân sách',
                description:
                    'Xác định ngân sách trước khi đi để tránh chi tiêu quá mức',
                color: Colors.green,
              ),
              _buildTipItem(
                context,
                icon: Icons.wb_sunny,
                title: 'Kiểm tra thời tiết',
                description:
                    'Theo dõi dự báo thời tiết để chuẩn bị trang phục phù hợp',
                color: Colors.orange,
              ),
              _buildTipItem(
                context,
                icon: Icons.medical_services,
                title: 'Mang theo thuốc cần thiết',
                description: 'Chuẩn bị túi thuốc y tế cơ bản cho chuyến đi',
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(
    final BuildContext context, {
    required final IconData icon,
    required final String title,
    required final String description,
    required final Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
