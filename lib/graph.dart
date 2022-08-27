import 'package:flutter/material.dart';

class Graph extends CustomPainter {
  Graph(this.data, this.offset, this.graphStepSize, this.signalStepSize);

  final List<int> data;
  final Offset offset;
  final double graphStepSize;
  final double signalStepSize;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    Paint meshPaint = Paint()..color = Colors.black26;
    Paint axisPaint = Paint()..color = Colors.red;
    Paint linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    Offset originPoint = Offset(graphStepSize, size.height / 2) + offset;

    // draw mesh
    for (double i = originPoint.dx; i <= size.width; i += graphStepSize) {
      // vertical lines (starts from origin then go right)
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), meshPaint);
    }
    for (double i = originPoint.dx; i >= 0; i -= graphStepSize) {
      // vertical lines (starts from origin then go left)
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), meshPaint);
    }
    for (double i = originPoint.dy; i <= size.height; i += graphStepSize) {
      // horizontal lines (starts from origin then go down)
      canvas.drawLine(Offset(0, i), Offset(size.width, i), meshPaint);
    }
    for (double i = originPoint.dy; i >= 0; i -= graphStepSize) {
      // horizontal lines (starts from origin then go up)
      canvas.drawLine(Offset(0, i), Offset(size.width, i), meshPaint);
    }

    // draw x-axis
    canvas.drawLine(Offset(0, originPoint.dy), Offset(size.width, originPoint.dy), axisPaint);
    // draw y-axis
    canvas.drawLine(Offset(originPoint.dx, 0), Offset(originPoint.dx, size.height), axisPaint);

    if (data.isEmpty) return;

    Path path = Path();
    path.moveTo(originPoint.dx, originPoint.dy + (data[0] * -signalStepSize));

    for (var i = 0; i < data.length; i++) {
      // starting point
      double x1 = (i * signalStepSize);
      double y1 = data[i] * -signalStepSize;
      path.lineTo(originPoint.dx + x1, originPoint.dy + y1);

      // ending point
      double x2 = (i * signalStepSize) + signalStepSize;
      double y2 = data[i] * -signalStepSize;
      path.lineTo(originPoint.dx + x2, originPoint.dy + y2);
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
