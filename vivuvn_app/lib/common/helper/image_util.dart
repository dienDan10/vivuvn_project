import 'dart:math';

import 'package:flutter/material.dart';

class ImageUtil {
  static ImageProvider<Object> getImageProvider(final String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      // Generate a random number between 1 and 10
      final random = Random();
      final randomNumber = random.nextInt(10) + 1;
      return AssetImage('assets/images/avatar-$randomNumber.png');
    } else if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage(imageUrl);
    }
  }
}
