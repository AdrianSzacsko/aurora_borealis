import 'dart:ui';

import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';

class CustomShape extends StatelessWidget {
  final Widget child;

  CustomShape({Key? key, required this.child, this.color}) : super(key: key);

  MaterialColor? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color?? primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(20))
          ),
          child: child,
        ),
        CustomPaint(
          size: const Size(15,15),
          painter: TrianglePainter(color?? primaryColor),
        )
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {

  TrianglePainter(this.color);

  MaterialColor color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width/2, size.height)
      ..lineTo(0, 0)
      /*..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)*/
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}