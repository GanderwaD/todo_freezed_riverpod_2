/*
 * ---------------------------
 * File : dialog_animation.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as math;

rotateAnimation({
  required Widget child,
  required Animation<double> animation,
}) {
  return Transform.rotate(
    angle: math.radians(animation.value * 360),
    child: Opacity(
      opacity: animation.value,
      child: child,
    ),
  );
}

scaleAnimation({
  required Widget child,
  required Animation<double> animation,
}) {
  return Transform.scale(
    scale: animation.value,
    child: Opacity(
      opacity: animation.value,
      child: child,
    ),
  );
}

slideInDownAnimation({
  required Widget child,
  required Animation<double> animation,
}) {
  final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1.0;
  return Transform(
    transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
    child: Opacity(
      opacity: animation.value,
      child: child,
    ),
  );
}

slideInUpAnimation({
  required Widget child,
  required Animation<double> animation,
}) {
  final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1.0;
  return Transform(
    transform: Matrix4.translationValues(0.0, curvedValue * -200, 0.0),
    child: Opacity(
      opacity: animation.value,
      child: child,
    ),
  );
}

slideInLeftAnimation({
  required Widget child,
  required Animation<double> animation,
}) {
  final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1.0;
  return Transform(
    transform: Matrix4.translationValues(curvedValue * 200, 0.0, 0.0),
    child: Opacity(
      opacity: animation.value,
      child: child,
    ),
  );
}

slideInRightAnimation({
  required Widget child,
  required Animation animation,
}) {
  final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1.0;
  return Transform(
    transform: Matrix4.translationValues(curvedValue * -200, 0, 0),
    child: Opacity(
      opacity: animation.value,
      child: child,
    ),
  );
}
