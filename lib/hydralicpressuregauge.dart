import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../variable.dart';

class HydraulicPressureGauge extends StatelessWidget {
  final int HydraulicPressure;
  HydraulicPressureGauge(this.HydraulicPressure);

  @override
  Widget build(BuildContext context) {
    print("batteryvalue1 ${HydraulicPressure}");

    // String = data.toString();

    return Stack(
      alignment: Alignment.center,
      children: [
        CircularArc(key: UniqueKey(), HydraulicPressure: HydraulicPressure),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.222,
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.03,
            backgroundColor: Color.fromARGB(235, 243, 207, 3),
            child: Text(
              '${HydraulicPressure.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.022,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CircularArc extends StatefulWidget {
  final int HydraulicPressure;
  const CircularArc({Key? key, required this.HydraulicPressure})
      : super(key: key);

  @override
  _CircularArcState createState() => _CircularArcState();
}

class _CircularArcState extends State<CircularArc>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animController;
  double calculation = 0.0;
  double beginvalue = 0.0;
  double endvalue = 0.0;

  @override
  void initState() {
    super.initState();
    print("batteryvalue inside ${widget.HydraulicPressure}");
    calculation = widget.HydraulicPressure / 300;
    beginvalue = 0.0;
    endvalue = 4.6 * calculation;
    animController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    final curvedAnimation =
        CurvedAnimation(parent: animController, curve: Curves.easeInOutCubic);
    animation =
        Tween<double>(begin: beginvalue, end: endvalue).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });

    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(
          MediaQuery.of(context).size.width * 0.9,
          MediaQuery.of(context).size.height * 0.4,
        ),
        painter: ProgressArc(animation.value, Color(0xFFFF0000), true, context),
      ),
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}

class ProgressArc extends CustomPainter {
  bool isBackground;
  double arc;
  Color progressColor;
  BuildContext context; // Add context as a property

  ProgressArc(this.arc, this.progressColor, this.isBackground, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = MediaQuery.of(context).size.width * 0.08;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );
    final startAngle = math.pi * 2.76;
    final sweepAngle = arc != null ? arc : math.pi;
    final useCenter = false;

    if (isBackground) {
      final borderColor = Color.fromARGB(255, 255, 255, 255);

      final backgroundPaint = Paint()
        ..color = Color.fromARGB(255, 146, 146, 146)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = MediaQuery.of(context).size.width * 0.02;

      final startAngleBackground = math.pi * 0.93 - (math.pi / 6);
      final sweepAngleBackground = math.pi * 1.46;

      canvas.drawArc(rect, startAngleBackground, sweepAngleBackground,
          useCenter, backgroundPaint);
      canvas.drawArc(
        rect,
        startAngleBackground,
        sweepAngleBackground,
        useCenter,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = MediaQuery.of(context).size.width * 0.015,
      );
    }

    Color arcColor = (DataHolder.HydraulicPressure > 30 && DataHolder.HydraulicPressure < 270)
        ? Colors.green
        : Colors.red;

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = MediaQuery.of(context).size.width * 0.015;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
