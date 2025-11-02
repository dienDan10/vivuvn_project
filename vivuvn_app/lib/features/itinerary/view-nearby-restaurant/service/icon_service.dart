import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'iicon_service.dart';

class IconService implements IIconService {
  @override
  Future<BitmapDescriptor> createCustomMarkerBitmap(
    final String path, {
    final double size = 48.0,
  }) async {
    return await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(size, size)),
      path,
    );
  }

  @override
  Future<Uint8List> getBytesFromAsset(
    final String path,
    final int width,
  ) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  @override
  Future<Uint8List> widgetToBytes(final GlobalKey key) async {
    final RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!.buffer.asUint8List();
  }
}

final iconServiceProvider = Provider.autoDispose<IIconService>((final ref) {
  return IconService();
});
