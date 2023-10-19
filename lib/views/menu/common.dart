import 'package:flutter/material.dart';
//import 'dart:math';

class Common extends StatelessWidget {
  //final numberOfBackLines = 4;
  final Widget content;

  const Common(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    /*var backLines = <Widget>[];

    for (var i = 0; i < numberOfBackLines; i++) {
      backLines.insert(
          i * 2,
          CustomPaint(
            size: const Size(double.infinity, 10.0),
            painter: BackgroundLine(color: Colors.blueAccent),
          ));
      backLines.insert(
          i * 2 + 1,
          CustomPaint(
            size: const Size(double.infinity, 10.0),
            painter: BackgroundLine(color: Colors.transparent),
          ));
    }*/

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.red,
            Colors.grey
            //Color.fromARGB(255, 59, 43, 42),
          ],
        ),
      ),
      child: content,
      /*child: Column(
        children: backLines,
      ),*/
    );
  }
}

/*class BackgroundLine extends CustomPainter {
  final double angle;
  final double width;
  final Color color;

  BackgroundLine(
      {this.angle = 30, this.width = 10.0, this.color = Colors.transparent});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        Path()
          ..moveTo(0.0, size.height)
          ..lineTo(size.width, size.width * tan(angle * (pi / 180.0))),
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = width);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}*/
