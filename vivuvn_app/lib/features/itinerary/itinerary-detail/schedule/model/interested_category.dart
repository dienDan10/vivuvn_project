import 'package:flutter/material.dart';

class InterestCategory {
  final String name;
  final IconData icon;

  const InterestCategory({required this.name, required this.icon});
}

final List<InterestCategory> allInterests = [
  const InterestCategory(name: 'culture', icon: Icons.museum),
  const InterestCategory(name: 'history', icon: Icons.history_edu),
  const InterestCategory(name: 'nature', icon: Icons.nature_people),
  const InterestCategory(name: 'photography', icon: Icons.camera_alt),
  const InterestCategory(name: 'food', icon: Icons.restaurant),
  const InterestCategory(name: 'shopping', icon: Icons.shopping_bag),
  const InterestCategory(name: 'adventure', icon: Icons.hiking),
  const InterestCategory(name: 'relaxation', icon: Icons.beach_access),
  const InterestCategory(name: 'nightlife', icon: Icons.nightlife),
];
