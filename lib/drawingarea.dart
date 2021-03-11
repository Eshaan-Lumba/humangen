import 'dart:ui';
import 'package:flutter/material.dart';

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({this.point, this.areaPaint});
}

// CustomPainter allows us to draw on the widgets
class MyCustomPainter extends CustomPainter {

  // list holds all the points that the user will draw on the sketchpad
  // the exact data points the user draws on
  List<DrawingArea> points;

  MyCustomPainter({@required List<DrawingArea> points}):
  this.points = points.toList();

@override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.black;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i+1] != null) {
        canvas.drawLine(points[i].point, points[i+1].point, points[i].areaPaint);
      } else if (points[i] != null && points[i+1] == null) {
        canvas.drawPoints(PointMode.points, [points[i].point], points[i].areaPaint);
      }
    }
  }

  // algorithm that allows us to draw 
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return oldDelegate.points != points;
  }

}