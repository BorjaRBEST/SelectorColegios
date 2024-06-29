import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class IconosPersonalizados {
  static Future<BitmapDescriptor> getCustomMarker(int index) async {
    final colors = [
      Colors.green[600]!,
      Colors.green[400]!,
      Colors.green[200]!,
      Colors.blue[600]!,
      Colors.blue[400]!,
      Colors.blue[200]!,
      Colors.red[600]!,
      Colors.red[400]!,
      Colors.red[200]!,
      Colors.brown[600]!,
      Colors.brown[400]!,
      Colors.brown[200]!,
    ];

    final color = colors[index % colors.length];
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = color;

    final size = 30.0;
    final radius = size / 2;
    final textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(
      text: (index + 1).toString(),
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    // Draw circle
    canvas.drawCircle(Offset(radius, radius), radius, paint);

    // Draw number in the center of the circle
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }
}
