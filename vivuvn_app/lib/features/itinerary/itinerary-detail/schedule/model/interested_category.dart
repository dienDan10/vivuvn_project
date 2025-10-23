import 'package:flutter/material.dart';

class InterestCategory {
  final String name;
  final String vNameseName;
  final IconData icon;

  const InterestCategory({
    required this.name,
    required this.vNameseName,
    required this.icon,
  });
}

final List<InterestCategory> allInterests = [
  const InterestCategory(
    name: 'culture',
    vNameseName: 'Văn hóa',
    icon: Icons.museum,
  ),
  const InterestCategory(
    name: 'history',
    vNameseName: 'Lịch sử',
    icon: Icons.history_edu,
  ),
  const InterestCategory(
    name: 'nature',
    vNameseName: 'Thiên nhiên',
    icon: Icons.nature_people,
  ),
  const InterestCategory(
    name: 'photography',
    vNameseName: 'Nhiếp ảnh',
    icon: Icons.camera_alt,
  ),
  const InterestCategory(
    name: 'food',
    vNameseName: 'Ẩm thực',
    icon: Icons.restaurant,
  ),
  const InterestCategory(
    name: 'shopping',
    vNameseName: 'Mua sắm',
    icon: Icons.shopping_bag,
  ),
  const InterestCategory(
    name: 'adventure',
    vNameseName: 'Phiêu lưu',
    icon: Icons.hiking,
  ),
  const InterestCategory(
    name: 'relaxation',
    vNameseName: 'Thư giãn',
    icon: Icons.beach_access,
  ),
  const InterestCategory(
    name: 'nightlife',
    vNameseName: 'Đời sống về đêm',
    icon: Icons.nightlife,
  ),
];
