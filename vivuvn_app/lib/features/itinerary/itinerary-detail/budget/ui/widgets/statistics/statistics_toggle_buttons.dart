import 'package:flutter/material.dart';

/// Toggle buttons widget để chuyển đổi giữa Category và Day by day
class StatisticsToggleButtons extends StatelessWidget {
  const StatisticsToggleButtons({
    required this.showByType,
    required this.onToggle,
    super.key,
  });

  final bool showByType;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleButton(
              label: 'Theo loại chi phí',
              isSelected: showByType,
              onTap: () => onToggle(true),
            ),
          ),
          Expanded(
            child: _ToggleButton(
              label: 'Theo ngày',
              isSelected: !showByType,
              onTap: () => onToggle(false),
            ),
          ),
        ],
      ),
    );
  }
}

/// Single toggle button
class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black87 : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
