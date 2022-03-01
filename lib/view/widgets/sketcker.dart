import 'package:flutter/material.dart';
import 'package:note/models/draw_line.dart';

class Sketcher extends CustomPainter {
  final List<DrawLine?> lines;

  Sketcher({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < lines.length; ++i) {
      if (lines[i] == null) continue;
      for (int j = 0; j < lines[i]!.path.length - 1; ++j) {
        if (lines[i]?.path[j] != null && lines[i]?.path[j + 1] != null) {
          paint.color = Color(lines[i]!.colorHex);
          paint.strokeWidth = lines[i]!.width;
          Offset p1 = Offset(lines[i]!.path[j].dx, lines[i]!.path[j].dy);
          Offset p2 =
              Offset(lines[i]!.path[j + 1].dx, lines[i]!.path[j + 1].dy);
          canvas.drawLine(p1, p2, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
  }
}
