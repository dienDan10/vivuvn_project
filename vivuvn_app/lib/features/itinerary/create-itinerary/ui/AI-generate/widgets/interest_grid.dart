import 'package:flutter/material.dart';

import '../../../models/interested_category.dart';

class InterestGrid extends StatelessWidget {
  final ScrollController controller;
  final Set<InterestCategory> selectedInterests;
  final void Function(InterestCategory) onToggle;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;

  const InterestGrid({
    super.key,
    required this.controller,
    required this.selectedInterests,
    required this.onToggle,
    this.crossAxisCount = 3,
    this.crossAxisSpacing = 15,
    this.mainAxisSpacing = 15,
    this.childAspectRatio = 0.9,
  });

  @override
  Widget build(final BuildContext context) {
    return GridView.builder(
      controller: controller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: allInterests.length,
      itemBuilder: (final context, final index) {
        final interest = allInterests[index];
        final isSelected = selectedInterests.contains(interest);

        return GestureDetector(
          onTap: () => onToggle(interest),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  interest.icon,
                  size: 40,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
                const SizedBox(height: 8),
                Text(
                  interest.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
