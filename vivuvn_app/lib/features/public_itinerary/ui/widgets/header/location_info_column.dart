import 'package:flutter/material.dart';

class LocationInfoColumn extends StatelessWidget {
  final String? startProvinceName;
  final String? destinationProvinceName;
  final IconData? secondaryIcon;
  final String? secondaryLabel;
  final ThemeData theme;

  const LocationInfoColumn({
    required this.theme,
    this.startProvinceName,
    this.destinationProvinceName,
    this.secondaryIcon,
    this.secondaryLabel,
    super.key,
  });

  Widget _buildProvinceRow(final String provinceName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.place, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            provinceName,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    final hasStart = startProvinceName != null && startProvinceName!.isNotEmpty;
    final hasDestination = destinationProvinceName != null && destinationProvinceName!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Điểm đi
        if (hasStart) _buildProvinceRow(startProvinceName!),
        // Mũi tên chỉ hướng
        if (hasStart && hasDestination)
          const Padding(
            padding: EdgeInsets.only(left: 26, top: 2, bottom: 2),
            child: Icon(
              Icons.arrow_downward,
              size: 16,
              color: Colors.white,
            ),
          ),
        // Điểm đến
        if (hasDestination) _buildProvinceRow(destinationProvinceName!),
        // Secondary info (ngày tháng)
        if (secondaryIcon != null && secondaryLabel != null) ...[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(secondaryIcon, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  secondaryLabel!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

