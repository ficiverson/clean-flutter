import 'dart:math';

import 'package:cleanflutter/ui/animation/background_flight.dart';
import 'package:cleanflutter/ui/utils/uxhelper/app_colors.dart';
import 'package:flutter/material.dart';

class FlightAnimation extends StatefulWidget {
  @override
  _FlightAnimationState createState() =>
      new _FlightAnimationState();
}

class _FlightAnimationState extends State<FlightAnimation>
    with SingleTickerProviderStateMixin {

  static const FACE_LEFT_ANGLE = -pi / 3;
  static const FACE_RIGHT_ANGLE = -5 * pi / 4;


  AnimationController _controller;
  Animation _animation;
  Animation<double> animationBackground;
  Alignment initAngleState = Alignment.topLeft;
  Alignment endAngleState = Alignment.bottomRight;

  double _angle = FACE_RIGHT_ANGLE;

  @override
  void initState() {
    super.initState();

    //jet controller
    _controller = new AnimationController(
        duration: new Duration(seconds: 2),
        vsync: this
    )
      ..addListener(() {
        this.setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _angle = FACE_LEFT_ANGLE;
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _angle = FACE_RIGHT_ANGLE;
          _controller.forward();
        }
      });

    Tween _tween = new AlignmentTween(
      begin: initAngleState,
      end: endAngleState,
    );

    _animation = _tween.animate(_controller);

    animationBackground =
    new CurvedAnimation(parent: _controller, curve: new ElasticOutCurve(0.6));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new CustomPaint(
          painter:
          new BackgroundPainter(
              animationBackground.value < 0 ? animationBackground.value : 1 -
                  animationBackground.value, new Offset(200.0, 150.0)),
          child: new Container(height: MediaQuery
              .of(context)
              .size
              .height, width: MediaQuery
              .of(context)
              .size
              .width),
        ),
        new FractionallySizedBox(
            heightFactor: 0.3,
            widthFactor: 0.3,
            alignment: _animation.value,
            child: new Transform.rotate(
              angle: _angle,
              child: new Icon(
                //REPLACEME
                Icons.flight,
                // Icons.radio,
                color: AppColors.blue_bubble,
                size: 90.0,
              ),
            )
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}