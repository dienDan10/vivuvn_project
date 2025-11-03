import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageUtil {
  static ImageProvider<Object> getImageProvider(final String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      // Use the JPEG placeholder since ImageProvider doesn't support SVG
      return const AssetImage('assets/images/image-placeholder.jpeg');
    } else if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage(imageUrl);
    }
  }

  /// Returns a Widget for avatar display that supports both network images and SVG placeholders
  static Widget buildAvatarWidget({
    required final String? imageUrl,
    required final double radius,
  }) {
    if (imageUrl == null || imageUrl.isEmpty) {
      // Use random SVG avatar
      // final random = Random();
      // final randomNumber = random.nextInt(10) + 1;
      return ClipOval(
        child: SvgPicture.asset(
          'assets/images/avatar-1.svg',
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
        ),
      );
    } else if (imageUrl.startsWith('http')) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl),
      );
    } else if (imageUrl.endsWith('.svg')) {
      return ClipOval(
        child: SvgPicture.asset(
          imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(imageUrl),
      );
    }
  }
}
