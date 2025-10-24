import 'package:flutter/material.dart';

class ScanFramePainter extends CustomPainter {
  final double stroke, radius, gap, length;
  final Color color;
  
  ScanFramePainter({
    required this.stroke,
    required this.radius,
    required this.gap,
    required this.length,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inner = Rect.fromLTWH(gap, gap, rect.width - gap * 2, rect.height - gap * 2);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    void corner(Offset o, double dx, double dy) {
      canvas.drawLine(o, o + Offset(dx * length, 0), p);
      canvas.drawLine(o, o + Offset(0, dy * length), p);
    }

    corner(inner.topLeft, 1, 1);
    corner(Offset(inner.right, inner.top), -1, 1);
    corner(Offset(inner.left, inner.bottom), 1, -1);
    corner(Offset(inner.right, inner.bottom), -1, -1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}