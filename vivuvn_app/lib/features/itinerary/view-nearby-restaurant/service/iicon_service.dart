import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract interface class IIconService {
  Future<BitmapDescriptor> createCustomMarkerBitmap(
    final String path, {
    final double size = 48.0,
  });
  Future<Uint8List> getBytesFromAsset(final String path, final int width);
  Future<Uint8List> widgetToBytes(final GlobalKey key);
}
