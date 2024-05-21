import 'package:flutter/material.dart';

// ignore: camel_case_types
class customPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 15;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, 50, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
