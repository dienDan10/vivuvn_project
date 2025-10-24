import 'package:flutter/material.dart';

/// Icon mapping utilities cho budget types
class BudgetTypeIcons {
  const BudgetTypeIcons._();

  /// Get icon cho budget type dựa vào tên
  static IconData getIconForType(final String typeName) {
    final lowerName = typeName.toLowerCase();

    if (lowerName.contains('uống')) {
      return Icons.coffee;
    } else if (lowerName.contains('di chuyển') || lowerName.contains('xe')) {
      return Icons.directions_car;
    } else if (lowerName.contains('khách sạn') ||
        lowerName.contains('nghỉ') ||
        lowerName.contains('ở')) {
      return Icons.hotel;
    } else if (lowerName.contains('giải trí') ||
        lowerName.contains('vui chơi') ||
        lowerName.contains('hoạt động')) {
      return Icons.celebration;
    } else if (lowerName.contains('mua sắm')) {
      return Icons.shopping_bag;
    } else if (lowerName.contains('vé')) {
      return Icons.confirmation_number;
    } else if (lowerName.contains('khác')) {
      return Icons.more_horiz;
    } else if (lowerName.contains('bay') || lowerName.contains('vé máy bay')) {
      return Icons.flight;
    } else if (lowerName.contains('vận chuyển')) {
      return Icons.local_shipping;
    } else if (lowerName.contains('thực phẩm')) {
      return Icons.food_bank;
    } else if (lowerName.contains('du lịch')) {
      return Icons.location_city;
    } else if (lowerName.contains('xăng')) {
      return Icons.gas_meter;
    } else {
      return Icons.shopping_cart;
    }
  }
}
