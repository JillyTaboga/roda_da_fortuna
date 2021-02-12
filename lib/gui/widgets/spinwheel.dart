import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roda_da_fortuna/controllers/game_controller.dart';
import 'package:roda_da_fortuna/controllers/sound_controller.dart';
import 'package:roda_da_fortuna/repositories/wheelpoints.dart';

typedef OnStop(double value);

class SpinWheel extends StatefulWidget {
  SpinWheel({
    Key key,
    @required this.onStop,
    @required this.onTurn,
  }) : super(key: key);

  final OnStop onStop;
  final bool onTurn;

  @override
  _SpinWheelState createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  double angle;
  bool foward = true;
  bool spinning = false;
  double mathAngle = 0.02617;
  bool clack = false;
  bool onTurn;
  FocusNode wheelFocus = FocusNode();
  bool focused = false;

  @override
  void initState() {
    super.initState();
    angle = 0.02617;
    onTurn = widget.onTurn;
    wheelFocus.addListener(() {
      if (wheelFocus.hasFocus) {
        setState(() {
          focused = true;
        });
      } else {
        setState(() {
          focused = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(SpinWheel oldWidget) {
    onTurn = widget.onTurn;
    if (onTurn) {
      wheelFocus.requestFocus();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    wheelFocus.dispose();
    super.dispose();
  }

  _forward() {
    setState(() {
      angle += mathAngle;
      foward = true;
      clack = true;
    });
  }

  _reverse() {
    setState(() {
      angle -= mathAngle;
      foward = false;
      clack = true;
    });
  }

  _impulse() async {
    spinning = true;
    final max = 600 + (Random().nextInt(200));
    var interval = 70;
    for (var n = 0; n < max; n++) {
      await Future.delayed(Duration(microseconds: interval));
      interval += (n * 0.1).floor();
      if (mounted) {
        setState(() {
          clack = true;
          if (foward) {
            angle += mathAngle;
          } else {
            angle -= mathAngle;
          }
        });
      }
    }
    if (mounted) {
      spinning = false;
      final degree = (angle * 180 / pi);
      final turns = (degree % 360 / 360);
      final points = wheelPoints.reversed.toList();
      final position =
          (((turns / 0.041666) - 0.8).round() > (points.length - 1) ||
                  ((turns / 0.041666) - 0.8).round() < 0)
              ? 0
              : ((turns / 0.041666) - 0.8).round();
      final value = points[position];
      setState(() {
        clack = false;
      });
      widget.onStop(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(builder: (gameController) {
      if (!spinning && gameController.autoSpin) {
        _impulse();
      }
      return Opacity(
        opacity: 0.99,
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(15),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: focused ? Colors.blue.shade100 : Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
                color: Colors.white,
              )),
          child: GestureDetector(
            onPanEnd: onTurn
                ? (drag) {
                    if (!spinning) _impulse();
                  }
                : null,
            onPanUpdate: onTurn
                ? (drag) {
                    if (!spinning) {
                      if (drag.localPosition.dx > 200) {
                        if (drag.delta.dy > 0.5) _forward();
                        if (drag.delta.dy < -0.5) _reverse();
                      }
                      if (drag.localPosition.dx < 200) {
                        if (drag.delta.dy > 0.5) _reverse();
                        if (drag.delta.dy < -0.5) _forward();
                      }
                      if (drag.localPosition.dy < 200) {
                        if (drag.delta.dx > 0.5) _forward();
                        if (drag.delta.dx < -0.5) _reverse();
                      }
                      if (drag.localPosition.dy > 200) {
                        if (drag.delta.dx > 0.5) _reverse();
                        if (drag.delta.dx < -0.5) _forward();
                      }
                    }
                  }
                : null,
            child: InkWell(
              borderRadius: BorderRadius.circular(1000),
              focusColor: Colors.white.withOpacity(0.1),
              focusNode: wheelFocus,
              onTap: () {
                if (!spinning && onTurn) _impulse();
              },
              child: Stack(
                alignment: Alignment.topCenter,
                fit: StackFit.expand,
                children: [
                  Transform.rotate(
                    angle: angle,
                    child: Opacity(
                      opacity: 0.99,
                      child: Image.asset(
                        'assets/rodaroda.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.only(right: 0),
                      width: Get.width,
                      child: Center(
                        child: Clack(
                          foward: foward,
                          clack: clack,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class Clack extends StatefulWidget {
  const Clack({
    Key key,
    @required this.foward,
    @required this.clack,
  });

  final bool foward;
  final bool clack;

  @override
  _ClackState createState() => _ClackState();
}

class _ClackState extends State<Clack> with TickerProviderStateMixin {
  AnimationController animationController;
  Tween<double> _animation;
  double clackConstant = 0.03;
  double clackAngle;
  bool clacking = false;
  bool foward;

  _clackIn() async {
    if (mounted) {
      clacking = true;
      _animation = Tween(begin: clackConstant, end: foward ? -0.25 : 0.25);
    }
    if (mounted) {
      animationController.reset();
    }
    if (mounted) {
      animationController.forward();
      Get.find<SoundController>().playClack();
      await Future.delayed(Duration(milliseconds: 200));
    }
    if (mounted) {
      animationController.reverse();
      clacking = false;
    }
  }

  @override
  void initState() {
    super.initState();
    foward = widget.foward;
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 200),
    );
    _animation = Tween(begin: clackConstant, end: widget.foward ? -0.25 : 0.25);
    if (widget.clack) _clackIn();
  }

  @override
  void didUpdateWidget(Clack oldWidget) {
    foward = widget.foward;
    if (widget.clack && !clacking && mounted) _clackIn();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      alignment: Alignment.topCenter,
      turns: _animation.animate(animationController),
      child: Container(
        height: Get.height / 28,
        width: 5,
        color: Colors.black,
      ),
    );
  }
}
