import 'dart:math';
import 'dart:ui' as ui;
import 'package:vector_math/vector_math.dart' as Vector;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart' show timeDilation;

class Wave extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;

  Wave({Key key, @required this.size, this.xOffset, this.yOffset, this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new WaveBody();
  }
}

class WaveBody extends State<Wave> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset;
          i <= widget.size.width.toInt() + 2;
          i++) {
        animList1.add(new Offset(
            i.toDouble() + widget.xOffset,
            sin((animationController.value * 360 - i) %
                        360 *
                        Vector.degrees2Radians) *
                    20 +
                50 +
                widget.yOffset));
      }
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        alignment: Alignment.center,
        child: new AnimatedBuilder(
          animation: new CurvedAnimation(
            parent: animationController,
            curve: Curves.fastOutSlowIn,
          ),
          builder: (context, child) => Stack(
                children: [
                  new CustomPaint(
                    painter: MyPaint(animationController.value, animList1),
                    child: new Container(
                      width: widget.size.width,
                      height: widget.size.height,

                      //color: widget.color,
                    ),
                  ),
                  new ClipPath(
                    child: new Container(
                      width: widget.size.width,
                      height: widget.size.height,
                      decoration: BoxDecoration(
                        color: widget.color,
                        border: Border(
                          top: BorderSide(color: Colors.black, width: 5.0),
                        ),
                      ),
                      //color: widget.color,
                    ),
                    clipper:
                        new WaveClipper(animationController.value, animList1),
                  ),
                ],
              ),
        ));
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}

class MyPaint extends CustomPainter {
  final double animation;

  List<Offset> waveList1 = [];

  MyPaint(this.animation, this.waveList1);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = Colors.black;

    Path path = new Path();

    path.addPolygon(waveList1, false);

    // path.lineTo(size.width, size.height);
    // path.lineTo(0.0, size.height);
    // path.close();
    canvas.drawPath(path, myPaint);
  }

  Paint myPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10.0
    ..color = Colors.black;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
